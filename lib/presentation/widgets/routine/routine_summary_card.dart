import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../screens/routine/routine_edit_screen.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../di/service_locator.dart';

/// 루틴 요약 카드 위젯
class RoutineSummaryCard extends StatefulWidget {
  final DailyRoutine routine;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;

  const RoutineSummaryCard({
    super.key,
    required this.routine,
    required this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
  });

  @override
  State<RoutineSummaryCard> createState() => _RoutineSummaryCardState();
}

class _RoutineSummaryCardState extends State<RoutineSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
                    ? AppTheme.primaryColor.withOpacity(0.3)
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
                
                // 루틴 정보 (활동 개수, 소요시간 등)
                _buildRoutineInfo(),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // 설명 (있을 경우)
                if (widget.routine.description.isNotEmpty) ...[ 
                  _buildDescription(),
                  const SizedBox(height: AppTheme.spacingM),
                ],
                
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
                color: AppTheme.primaryColor.withOpacity(0.3),
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
                    ? Colors.red.withOpacity(0.1)
                    : AppTheme.dividerColor.withOpacity(0.3),
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
        
        const SizedBox(width: AppTheme.spacingS),
        
        // 더보기 버튼
        GestureDetector(
          onTap: _showMoreOptions,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.dividerColor.withOpacity(0.3),
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

  Widget _buildRoutineInfo() {
    final totalMinutes = widget.routine.items.fold<int>(
      0,
      (sum, item) => sum + item.duration.inMinutes,
    );
    
    final completedCount = widget.routine.items.where((item) => item.isCompleted).length;
    final progressPercent = widget.routine.items.isNotEmpty 
        ? (completedCount / widget.routine.items.length * 100).round()
        : 0;

    return Row(
      children: [
        // 활동 개수
        _buildInfoChip(
          icon: Icons.list_alt,
          label: '${widget.routine.items.length}개 활동',
          color: AppTheme.accentColor,
        ),
        
        const SizedBox(width: AppTheme.spacingS),
        
        // 총 소요시간
        _buildInfoChip(
          icon: Icons.schedule,
          label: _formatDuration(totalMinutes),
          color: AppTheme.primaryColor,
        ),
        
        const SizedBox(width: AppTheme.spacingS),
        
        // 진행률
        _buildInfoChip(
          icon: Icons.check_circle,
          label: '$progressPercent% 완료',
          color: progressPercent > 50 ? Colors.green : Colors.orange,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
      final routineRepository = getIt<RoutineRepository>();
      
      // 새로운 ID와 제목으로 복사본 생성
      final copiedRoutine = widget.routine.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '${widget.routine.title} (복사본)',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        usageCount: 0,
        isFavorite: false,
      );

      // 복사본 저장
      await routineRepository.saveRoutine(copiedRoutine);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('루틴이 복사되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('루틴 복사에 실패했어요: $e'),
            backgroundColor: Colors.red,
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
    final timeGroups = <String, List<dynamic>>{
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
    shareText.writeln('📱 RoutineCraft로 만든 루틴입니다!');

    // 클립보드에 복사
    Clipboard.setData(ClipboardData(text: shareText.toString()));
    
    // 공유 옵션 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 공유하기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('루틴이 클립보드에 복사되었습니다!'),
            const SizedBox(height: 16),
            const Text('공유할 방법을 선택하세요:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('텍스트가 클립보드에 복사되었습니다'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.content_copy),
                      iconSize: 32,
                    ),
                    const Text('복사완료', style: TextStyle(fontSize: 12)),
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

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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