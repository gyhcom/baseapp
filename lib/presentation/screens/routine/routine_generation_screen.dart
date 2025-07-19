import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/routine_concept.dart';
import '../../../domain/entities/ai_routine_request.dart';
import '../../../data/repositories/claude_ai_service_impl.dart';
import '../../../core/constants/api_constants.dart';

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
  Map<String, dynamic>? _generatedRoutine;
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
        _currentStatus = '개인화된 루틴을 생성하고 있어요...';
      });

      final request = AIRoutineRequest(
        name: widget.name,
        age: widget.age,
        job: widget.job,
        hobbies: widget.hobbies,
        concept: widget.concept,
        additionalInfo: widget.additionalInfo,
      );

      // Claude AI 서비스 생성
      final dio = Dio();
      final aiService = ClaudeAIServiceImpl(
        apiKey: EnvironmentConfig.claudeApiKey,
        dio: dio,
      );

      // API 키 설정 확인
      final response = await aiService.generateRoutine(request);

      if (response.success && response.routine != null) {
        setState(() {
          _currentStatus = '루틴 생성이 완료되었어요!';
          _generatedRoutine = response.routine! as Map<String, dynamic>?;
          _isGenerating = false;
        });
        
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
              Navigator.of(context).pop();
              context.router.popUntilRoot();
            },
            child: const Text('홈으로'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _generateRoutine(); // 다시 생성
            },
            child: const Text('다시 생성'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoutineItems() {
    if (_generatedRoutine == null) return [];
    
    final List<Widget> items = [];
    
    // 추천 기상/취침 시간
    if (_generatedRoutine!['wakeUpTime'] != null) {
      items.add(Text('• 추천 기상시간: ${_generatedRoutine!['wakeUpTime']}'));
    }
    if (_generatedRoutine!['bedTime'] != null) {
      items.add(Text('• 추천 취침시간: ${_generatedRoutine!['bedTime']}'));
    }
    
    // 주요 활동들
    if (_generatedRoutine!['activities'] != null) {
      final activities = _generatedRoutine!['activities'] as List;
      for (var activity in activities.take(3)) {
        items.add(Text('• ${activity['time']}: ${activity['activity']}'));
      }
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
                // 닫기 버튼
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => context.router.maybePop(),
                    icon: const Icon(Icons.close),
                  ),
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