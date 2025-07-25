import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/routine_item.dart';
import '../../screens/routine/routine_edit_screen.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/services/routine_limit_service.dart';
import '../../../core/constants/routine_limits.dart';
import '../../../di/service_locator.dart';
import 'package:flutter/foundation.dart';

/// 루틴 요약 카드 위젯
class RoutineSummaryCard extends StatefulWidget {
  final DailyRoutine routine;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;
  final VoidCallback? onActiveToggle;

  const RoutineSummaryCard({
    super.key,
    required this.routine,
    required this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
    this.onCopy,
    this.onActiveToggle,
  });

  @override
  State<RoutineSummaryCard> createState() => _RoutineSummaryCardState();
}

class _RoutineSummaryCardState extends State<RoutineSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late bool _isActive; // 내부 활성화 상태 관리

  @override
  void initState() {
    super.initState();
    _isActive = widget.routine.isActive; // 초기 상태 설정
    _setupAnimations();
  }

  @override
  void didUpdateWidget(RoutineSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 위젯이 업데이트되면 내부 상태도 동기화
    if (oldWidget.routine.isActive != widget.routine.isActive) {
      _isActive = widget.routine.isActive;
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildCard(),
        );
      },
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: AppTheme.largeRadius,
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: AppTheme.largeRadius,
              boxShadow: [AppTheme.cardShadow],
              border: Border.all(
                color: widget.routine.isFavorite 
                    ? AppTheme.primaryColor.withValues(alpha: 0.3)
                    : AppTheme.dividerColor,
                width: widget.routine.isFavorite ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더 (제목, 컨셉, 액션)
                _buildHeader(),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // 상태 및 기본 정보
                _buildStatusRow(),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // 루틴 통계 정보
                _buildStatsGrid(),
                
                // 설명 (있을 경우)
                if (widget.routine.description.isNotEmpty) ...[ 
                  const SizedBox(height: AppTheme.spacingM),
                  _buildDescription(),
                ],
                
                const SizedBox(height: AppTheme.spacingM),
                
                // 하단 메타 정보
                _buildMetaInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // 컨셉 이모지
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradientDecoration,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.routine.concept.displayName.split(' ')[0], // 이모지 부분
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        
        const SizedBox(width: AppTheme.spacingM),
        
        // 제목과 컨셉명
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.routine.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 2),
              
              Text(
                widget.routine.concept.displayName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // 액션 버튼들
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 즐겨찾기 버튼
        if (widget.onFavoriteToggle != null)
          GestureDetector(
            onTap: widget.onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.routine.isFavorite 
                    ? Colors.red.withValues(alpha: 0.1)
                    : AppTheme.dividerColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.routine.isFavorite 
                    ? Icons.favorite 
                    : Icons.favorite_border,
                color: widget.routine.isFavorite 
                    ? Colors.red 
                    : AppTheme.textSecondaryColor,
                size: 20,
              ),
            ),
          ),
        
        if (widget.onFavoriteToggle != null)
          const SizedBox(width: AppTheme.spacingS),
        
        // 더보기 버튼
        GestureDetector(
          onTap: _showMoreOptions,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.dividerColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.more_vert,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  /// 상태 및 기본 정보 행
  Widget _buildStatusRow() {
    return Row(
      children: [
        // 활성화 상태
        _buildStatusBadge(),
        
        const SizedBox(width: AppTheme.spacingM),
        
        // 활동 개수
        Icon(
          Icons.list_alt,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${widget.routine.items.length}개 활동',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        
        const Spacer(),
        
        // 활성화 토글 스위치
        Transform.scale(
          scale: 0.8,
          child: Switch(
            key: ValueKey(_isActive), // 강제 리빌드
            value: _isActive,
            onChanged: (value) {
              debugPrint('🎛️ 루틴 카드 스위치 클릭: $value (현재: $_isActive)');
              _toggleActiveStatus();
            },
            activeColor: AppTheme.primaryColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  /// 활성화 상태 배지
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isActive 
            ? Colors.green.withValues(alpha: 0.1)
            : AppTheme.dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isActive 
              ? Colors.green.withValues(alpha: 0.3)
              : AppTheme.dividerColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isActive 
                ? Icons.notifications_active
                : Icons.notifications_off,
            key: ValueKey('status_icon_$_isActive'),
            size: 14,
            color: _isActive 
                ? Colors.green
                : AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            _isActive ? '활성화' : '비활성화',
            key: ValueKey('status_text_$_isActive'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _isActive 
                  ? Colors.green
                  : AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 통계 그리드 (2x2 레이아웃)
  Widget _buildStatsGrid() {
    final totalMinutes = widget.routine.items.fold<int>(
      0,
      (sum, item) => sum + item.duration.inMinutes,
    );
    
    final completedCount = widget.routine.items.where((item) => item.isCompleted).length;
    final progressPercent = widget.routine.items.isNotEmpty 
        ? (completedCount / widget.routine.items.length * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        children: [
          // 소요시간
          Expanded(
            child: _buildStatItem(
              icon: Icons.schedule,
              label: '소요시간',
              value: _formatDuration(totalMinutes),
              color: AppTheme.primaryColor,
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: AppTheme.dividerColor,
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          ),
          
          // 진행률
          Expanded(
            child: _buildStatItem(
              icon: Icons.check_circle,
              label: '완료율',
              value: '$progressPercent%',
              color: progressPercent > 50 ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  /// 통계 아이템
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }


  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Text(
        widget.routine.description,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondaryColor,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 생성일
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              _formatDate(widget.routine.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        
        // 사용 횟수
        if (widget.routine.usageCount > 0)
          Row(
            children: [
              Icon(
                Icons.play_arrow,
                size: 14,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.routine.usageCount}회 사용',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
      ],
    );
  }

  String _formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '날짜 없음';
    
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return '오늘';
    } else if (diff.inDays == 1) {
      return '어제';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else {
      return '${date.month}월 ${date.day}일';
    }
  }

  void _navigateToEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineEditScreen(routine: widget.routine),
      ),
    );
  }

  Future<void> _copyRoutine() async {
    try {
      // 로딩 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text('루틴 복사 중...'),
              ],
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }

      final routineRepository = getIt<RoutineRepository>();
      
      // 저장 제한 체크
      final currentCount = await routineRepository.getSavedRoutines();
      if (currentCount.length >= 5) { // 무료 사용자 제한
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('저장 공간이 가득 찼습니다. 기존 루틴을 삭제하거나 프리미엄으로 업그레이드하세요'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      
      // 새로운 ID와 제목으로 복사본 생성
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final copiedRoutine = widget.routine.copyWith(
        id: timestamp,
        title: '${widget.routine.title} (복사본)',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        usageCount: 0,
        isFavorite: false,
        // 루틴 아이템들도 새로운 ID로 복사
        items: widget.routine.items.map((item) => item.copyWith(
          id: '${timestamp}_${item.id}',
          isCompleted: false, // 복사본은 완료되지 않은 상태로
        )).toList(),
      );

      // 복사본 저장
      await routineRepository.saveRoutine(copiedRoutine);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 루틴이 성공적으로 복사되었습니다'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // 부모 화면에 복사 완료 알림
        widget.onCopy?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 루틴 복사에 실패했어요: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _shareRoutine() {
    // 루틴을 텍스트 형태로 변환
    final StringBuffer shareText = StringBuffer();
    shareText.writeln('📅 ${widget.routine.title}');
    shareText.writeln('');
    shareText.writeln('🎯 컨셉: ${widget.routine.concept.displayName}');
    
    if (widget.routine.description.isNotEmpty) {
      shareText.writeln('💭 설명: ${widget.routine.description}');
    }
    
    shareText.writeln('');
    shareText.writeln('⏰ 하루 루틴:');
    
    // 시간대별로 그룹화
    final timeGroups = <String, List<RoutineItem>>{
      '🌅 새벽 (05:00-07:59)': [],
      '🌞 오전 (08:00-11:59)': [],
      '☀️ 점심 (12:00-13:59)': [],
      '🌤️ 오후 (14:00-17:59)': [],
      '🌆 저녁 (18:00-20:59)': [],
      '🌙 밤 (21:00-23:59)': [],
      '🌚 심야 (00:00-04:59)': [],
    };

    for (final item in widget.routine.items) {
      final hour = item.startTime.hour;
      String timeGroup;
      
      if (hour >= 5 && hour < 8) {
        timeGroup = '🌅 새벽 (05:00-07:59)';
      } else if (hour >= 8 && hour < 12) {
        timeGroup = '🌞 오전 (08:00-11:59)';
      } else if (hour >= 12 && hour < 14) {
        timeGroup = '☀️ 점심 (12:00-13:59)';
      } else if (hour >= 14 && hour < 18) {
        timeGroup = '🌤️ 오후 (14:00-17:59)';
      } else if (hour >= 18 && hour < 21) {
        timeGroup = '🌆 저녁 (18:00-20:59)';
      } else if (hour >= 21 || hour < 0) {
        timeGroup = '🌙 밤 (21:00-23:59)';
      } else {
        timeGroup = '🌚 심야 (00:00-04:59)';
      }
      
      timeGroups[timeGroup]!.add(item);
    }

    // 시간대별로 출력
    for (final entry in timeGroups.entries) {
      if (entry.value.isNotEmpty) {
        shareText.writeln('');
        shareText.writeln('${entry.key}');
        for (final item in entry.value) {
          final startTime = item.timeDisplay;
          shareText.writeln('  • $startTime ${item.title} (${item.duration.inMinutes}분)');
        }
      }
    }
    
    shareText.writeln('');
    shareText.writeln('📱 RoutineCraft로 만든 개인 맞춤 루틴입니다!');
    shareText.writeln('🔗 앱에서 나만의 루틴을 만들어보세요');

    // 공유 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 공유하기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('어떤 방식으로 공유하시겠습니까?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Share.share(
                          shareText.toString(),
                          subject: '${widget.routine.title} - 나의 하루 루틴',
                        );
                      },
                      icon: const Icon(Icons.share),
                      iconSize: 32,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        foregroundColor: const Color(0xFF6366F1),
                      ),
                    ),
                    const Text('텍스트 공유', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Clipboard.setData(ClipboardData(text: shareText.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('텍스트가 클립보드에 복사되었습니다'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.content_copy),
                      iconSize: 32,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF059669).withValues(alpha: 0.1),
                        foregroundColor: const Color(0xFF059669),
                      ),
                    ),
                    const Text('클립보드 복사', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _shareAsImage();
                      },
                      icon: const Icon(Icons.image),
                      iconSize: 32,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626).withValues(alpha: 0.1),
                        foregroundColor: const Color(0xFFDC2626),
                      ),
                    ),
                    const Text('이미지로', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _shareAsImage() {
    // TODO: 이미지로 공유하는 기능 구현 (추후 구현)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('이미지 공유 기능은 준비 중입니다'),
        backgroundColor: Colors.orange,
      ),
    );
  }


  /// 루틴 활성화 상태 토글
  Future<void> _toggleActiveStatus() async {
    debugPrint('🔄 루틴 카드 활성화 토글 시작: ${widget.routine.title} (현재: $_isActive)');
    
    try {
      final routineRepository = getIt<RoutineRepository>();
      
      // 활성화하려는 경우 제한 검사
      if (!_isActive) {
        debugPrint('📊 활성화 제한 검사 중...');
        final canActivate = await RoutineLimitService.canActivateRoutine();
        debugPrint('📊 활성화 가능 여부: $canActivate');
        
        if (!canActivate) {
          debugPrint('❌ 활성화 제한으로 인해 실패');
          // 제한 초과 시 업그레이드 안내
          _showActivationLimitDialog();
          return;
        }
        
        // 무료 사용자는 기존 활성화된 루틴을 자동 비활성화 (현재 루틴 제외)
        final userTier = await RoutineLimitService.getUserTier();
        debugPrint('👤 사용자 등급: $userTier');
        if (userTier == UserTier.free) {
          debugPrint('🔧 기존 활성화된 루틴들 비활성화 중 (현재 루틴 제외: ${widget.routine.id})...');
          await routineRepository.deactivateAllRoutines(exceptRoutineId: widget.routine.id);
        }
      }
      
      // UI 상태를 먼저 낙관적으로 업데이트
      final expectedNewState = !_isActive;
      debugPrint('🎨 UI 상태 낙관적 업데이트: $expectedNewState');
      setState(() {
        _isActive = expectedNewState;
      });
      
      // 상태 토글
      debugPrint('🔧 데이터베이스에서 루틴 상태 토글 실행...');
      await routineRepository.toggleRoutineActive(widget.routine.id);
      debugPrint('✅ 데이터베이스 토글 완료');
      
      // 부모 위젯에 변경 알림
      widget.onActiveToggle?.call();
      
      // 성공 메시지
      final message = _isActive 
          ? '루틴이 활성화되었습니다. 알림과 추천을 받을 수 있습니다.' 
          : '루틴이 비활성화되었습니다.';
          
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: _isActive ? Colors.green : Colors.grey,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      debugPrint('🏁 루틴 카드 활성화 토글 완료: $_isActive');
      
    } catch (e) {
      debugPrint('❌ 루틴 카드 활성화 토글 실패: $e');
      
      // 실패 시 UI 상태를 원래대로 되돌림
      setState(() {
        _isActive = !_isActive;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('상태 변경에 실패했습니다: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 활성화 제한 다이얼로그 표시
  void _showActivationLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔒 활성화 제한'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '무료 사용자는 1개의 루틴만 활성화할 수 있습니다.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '프리미엄으로 업그레이드하면:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('✨ 무제한 루틴 활성화'),
            Text('✨ 무제한 루틴 저장'),
            Text('✨ 루틴당 최대 10개 활동'),
            Text('✨ 무제한 AI 루틴 생성'),
            Text('✨ 통계 및 분석 기능'),
            Text('✨ 백업 및 복원'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPremiumUpgradeInfo();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('프리미엄 알아보기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// 프리미엄 업그레이드 정보 표시
  void _showPremiumUpgradeInfo() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚧 프리미엄 기능은 준비 중입니다. 곧 출시될 예정입니다!'),
          backgroundColor: AppTheme.primaryColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                _isActive 
                    ? Icons.notifications_off 
                    : Icons.notifications_active,
                color: _isActive 
                    ? Colors.orange 
                    : AppTheme.primaryColor,
              ),
              title: Text(
                _isActive ? '루틴 비활성화' : '루틴 활성화',
                style: TextStyle(
                  color: _isActive 
                      ? Colors.orange 
                      : AppTheme.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleActiveStatus();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('루틴 수정'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('루틴 복사'),
              onTap: () {
                Navigator.pop(context);
                _copyRoutine();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('루틴 공유'),
              onTap: () {
                Navigator.pop(context);
                _shareRoutine();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('루틴 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}