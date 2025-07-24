import '../../../domain/entities/routine_item.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/routine_concept.dart';
import '../../../domain/entities/ai_routine_request.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../core/di/ai_service_provider.dart';
import '../../../core/config/ai_config.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/services/routine_limit_service.dart';
import '../../../core/constants/routine_limits.dart';
import '../../../di/service_locator.dart';
import 'routine_detail_screen.dart';
import 'my_routines_screen.dart';

/// AI 루틴 생성 화면
class RoutineGenerationScreen extends ConsumerStatefulWidget {
  final String name;
  final int age;
  final String job;
  final List<String> hobbies;
  final String additionalInfo;
  final RoutineConcept concept;

  const RoutineGenerationScreen({
    super.key,
    required this.name,
    required this.age,
    required this.job,
    required this.hobbies,
    required this.additionalInfo,
    required this.concept,
  });

  @override
  ConsumerState<RoutineGenerationScreen> createState() =>
      _RoutineGenerationScreenState();
}

class _RoutineGenerationScreenState extends ConsumerState<RoutineGenerationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  String _currentStatus = 'AI가 당신의 정보를 분석하고 있어요...';
  bool _isGenerating = true;
  DailyRoutine? _generatedRoutine;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateRoutine();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _generateRoutine() async {
    try {
      // 0단계: 사용량 체크 (더미 모드가 아닐 때만)
      if (!AIConfig.isDummyMode) {
        setState(() {
          _currentStatus = '사용량을 확인하고 있어요...';
        });
        
        final usageRepository = getIt<UsageRepository>();
        final canGenerate = await usageRepository.canGenerate();
        
        if (!canGenerate) {
          throw Exception('오늘 AI 루틴 생성 횟수를 모두 사용했습니다. 내일 다시 시도해주세요.');
        }
        
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // 1단계: 사용자 정보 분석
      setState(() {
        _currentStatus = 'AI가 당신의 정보를 분석하고 있어요...';
      });
      await Future.delayed(const Duration(seconds: 2));

      // 2단계: 컨셉 적용
      setState(() {
        _currentStatus = '${widget.concept.displayName} 컨셉을 적용하고 있어요...';
      });
      await Future.delayed(const Duration(seconds: 2));

      // 3단계: 루틴 생성  
      setState(() {
        _currentStatus = AIConfig.isDummyMode 
            ? '더미 데이터로 개인화된 루틴을 생성하고 있어요...'
            : '${AIConfig.config.name}가 개인화된 루틴을 생성하고 있어요...';
      });

      final request = AIRoutineRequest(
        name: widget.name,
        age: widget.age,
        job: widget.job,
        hobbies: widget.hobbies,
        concept: widget.concept,
        additionalInfo: widget.additionalInfo,
      );

      // AI 서비스 자동 선택 (설정에 따라 더미/실제 API 전환)
      final aiService = AIServiceProvider.createService();

      // API 키 설정 확인
      final response = await aiService.generateRoutine(request);

      // 실제 API 사용 시 사용량 차감
      if (!AIConfig.isDummyMode && response.success) {
        final usageRepository = getIt<UsageRepository>();
        await usageRepository.consumeGeneration();
      }

      if (response.success && response.routine != null) {
        setState(() {
          _currentStatus = '루틴 생성이 완료되었어요!';
          _generatedRoutine = response.routine!;
          _isGenerating = false;
        });
        
        // 자동으로 루틴 저장
        await _saveRoutineAutomatically(response.routine!);
        
        await Future.delayed(const Duration(seconds: 1));
        
        // 결과 화면으로 이동
        if (mounted) {
          _showRoutineResult();
        }
      } else {
        throw Exception(response.error ?? '루틴 생성에 실패했어요');
      }
    } catch (e) {
      print('루틴 생성 오류: $e');
      setState(() {
        _error = e.toString();
        _isGenerating = false;
        _currentStatus = '루틴 생성에 실패했어요';
      });
    }
  }

  void _showRoutineResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 루틴 생성 완료!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${widget.name}님만의 ${widget.concept.displayName} 루틴이 생성되었습니다!'),
              const SizedBox(height: 16),
              if (_generatedRoutine != null) ...[
                const Text('주요 루틴 항목:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._buildRoutineItems(),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 다이얼로그 닫기
              Navigator.of(context).pop();
              // 홈 화면이 있는 곳까지 pop하기
              Navigator.of(context).popUntil((route) {
                return route.settings.name?.contains('Home') == true || route.isFirst;
              });
            },
            child: const Text('홈으로'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToMyRoutines();
            },
            child: const Text('내 루틴 보기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToRoutineDetail();
            },
            child: const Text('루틴 상세보기'),
          ),
        ],
      ),
    );
  }

  void _navigateToRoutineDetail() {
    if (_generatedRoutine == null) return;
    
    // 루틴 상세 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineDetailScreen(routine: _generatedRoutine!),
      ),
    );
  }

  void _navigateToMyRoutines() {
    // 내 루틴 목록 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MyRoutinesScreen(),
      ),
    );
  }

  /// 루틴 자동 저장 (제한 검사 포함)
  Future<void> _saveRoutineAutomatically(DailyRoutine routine) async {
    try {
      // 저장 제한 검사
      final saveResult = await RoutineLimitService.validateAndPrepareForSave();
      
      print('🔍 저장 제한 검사 결과:');
      print('  - canSave: ${saveResult.canSave}');
      print('  - status: ${saveResult.status}');
      print('  - currentCount: ${saveResult.currentCount}');
      print('  - remainingSlots: ${saveResult.remainingSlots}');
      print('  - maxCount: ${saveResult.maxCount}');
      
      if (!saveResult.canSave) {
        print('❌ 저장 제한으로 인해 저장 불가');
        // 저장 불가능한 경우 사용자에게 알림
        if (mounted) {
          _showStorageLimitReached(saveResult);
        }
        return;
      }
      
      final routineRepository = getIt<RoutineRepository>();
      await routineRepository.saveRoutine(routine);
      
      print('✅ 루틴이 자동으로 저장되었습니다: ${routine.id}');
      print('📊 루틴 항목 개수: ${routine.items.length}');
      
      // 사용자 프로필도 저장 (최신 정보 유지)
      await routineRepository.saveUserProfile(routine.generatedFor);
      
      // 경고 상태인 경우 안내 메시지 표시
      if (mounted && saveResult.status == LimitStatus.warning) {
        _showStorageWarning(saveResult);
      }
      
    } catch (e) {
      print('❌ 루틴 저장 실패: $e');
      // 저장 실패해도 사용자에게는 알리지 않음 (UX 방해 방지)
    }
  }

  /// 저장 공간 한도 도달 알림
  void _showStorageLimitReached(RoutineSaveResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.folder_off, color: Colors.orange),
            SizedBox(width: 8),
            Text('저장 공간 부족'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('생성된 루틴을 저장할 수 없습니다.'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(result.warningMessage)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('해결 방법:'),
              const SizedBox(height: 8),
              const Text('• 기존 루틴을 삭제하여 공간 확보'),
              const Text('• 프리미엄 구독으로 무제한 저장'),
              const SizedBox(height: 16),
              const Text('* 루틴은 임시로 생성되었으며, 상세보기에서 확인할 수 있습니다.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showPremiumUpgradeDialog();
            },
            child: const Text('프리미엄 구독'),
          ),
        ],
      ),
    );
  }

  /// 저장 공간 경고 (토스트 메시지)
  void _showStorageWarning(RoutineSaveResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(result.warningMessage)),
          ],
        ),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: '프리미엄',
          textColor: Colors.white,
          onPressed: _showPremiumUpgradeDialog,
        ),
      ),
    );
  }

  /// 프리미엄 업그레이드 다이얼로그
  void _showPremiumUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Text('프리미엄 구독'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('프리미엄 구독의 혜택:'),
            SizedBox(height: 12),
            Text('✅ 무제한 AI 루틴 생성'),
            Text('✅ 루틴당 10개 항목 (무료: 5개)'),
            Text('✅ 고급 통계 및 분석'),
            Text('✅ 클라우드 백업'),
            Text('✅ 광고 없는 경험'),
            Text('✅ 우선 고객 지원'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('나중에'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 프리미엄 구독 페이지로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프리미엄 구독 기능 준비 중입니다')),
              );
            },
            child: const Text('구독하기'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoutineItems() {
    if (_generatedRoutine == null) return [];
    
    final List<Widget> items = [];
    
    try {
      // DailyRoutine 객체에서 정보 추출
      items.add(Text('• 컨셉: ${_generatedRoutine!.concept.displayName}'));
      
      // 상위 5개 루틴 아이템만 표시
      final routineItems = _generatedRoutine!.items.take(5);
      for (var item in routineItems) {
        final timeDisplay = item.timeDisplay; // RoutineItemX extension 사용
        items.add(Text('• $timeDisplay: ${item.title}'));
      }
      
      if (_generatedRoutine!.description.isNotEmpty) {
        items.add(const SizedBox(height: 8));
        items.add(Text('설명: ${_generatedRoutine!.description}'));
      }
    } catch (e) {
      print('루틴 아이템 빌드 오류: $e');
      items.add(const Text('루틴 정보를 표시할 수 없습니다.'));
    }
    
    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: item,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                // 상단 버튼들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home_outlined),
                      tooltip: '홈으로',
                      onPressed: () {
                        context.router.navigate(const HomeWrapperRoute());
                      },
                    ),
                    IconButton(
                      onPressed: () => context.router.maybePop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // AI 생성 아이콘
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: _isGenerating 
                              ? AppTheme.primaryGradientDecoration
                              : _error != null
                                  ? LinearGradient(
                                      colors: [Colors.red.shade400, Colors.red.shade600],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: [Colors.green.shade400, Colors.green.shade600],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [AppTheme.cardShadow],
                        ),
                        child: Icon(
                          _isGenerating 
                              ? Icons.auto_awesome 
                              : _error != null
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // 사용자 정보
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: AppTheme.mediumRadius,
                    boxShadow: [AppTheme.cardShadow],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                widget.concept.displayName.split(' ')[0], // 이모지
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.name}님의 ${widget.concept.displayName}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${widget.age}세 • ${widget.job}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      if (widget.hobbies.isNotEmpty) ...[ 
                        const SizedBox(height: AppTheme.spacingM),
                        const Divider(),
                        const SizedBox(height: AppTheme.spacingS),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '관심사: ${widget.hobbies.join(', ')}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // 상태 메시지
                Text(
                  _currentStatus,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // 진행률 표시
                if (_isGenerating) ...[ 
                  const LinearProgressIndicator(
                    backgroundColor: AppTheme.dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    '잠시만 기다려주세요...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
                
                // 에러 메시지
                if (_error != null) ...[ 
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: AppTheme.mediumRadius,
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '오류가 발생했어요',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          'API 키 설정을 확인해주세요. 현재 더미 키를 사용중입니다.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _error = null;
                        _isGenerating = true;
                      });
                      _generateRoutine();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
                
                const Spacer(),
                
                // 안내 문구
                if (_isGenerating)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: AppTheme.mediumRadius,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: AppTheme.accentColor,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Expanded(
                          child: Text(
                            '고품질의 개인화된 루틴을 생성하기 위해 AI가 열심히 작업중이에요!',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}