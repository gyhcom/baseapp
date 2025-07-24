import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../di/service_locator.dart';
import '../../screens/routine/routine_edit_screen.dart';
import 'card_components/routine_card_header.dart';
import 'card_components/routine_progress_section.dart';
import 'card_components/routine_items_preview.dart';
import 'card_components/routine_card_footer.dart';

/// 리팩토링된 루틴 요약 카드 위젯
class RoutineSummaryCardNew extends StatefulWidget {
  final DailyRoutine routine;
  final VoidCallback onTap;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onDelete;

  const RoutineSummaryCardNew({
    super.key,
    required this.routine,
    required this.onTap,
    this.onToggleFavorite,
    this.onDelete,
  });

  @override
  State<RoutineSummaryCardNew> createState() => _RoutineSummaryCardNewState();
}

class _RoutineSummaryCardNewState extends State<RoutineSummaryCardNew>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late bool _isActive;

  final RoutineRepository _routineRepository = getIt<RoutineRepository>();

  @override
  void initState() {
    super.initState();
    _isActive = widget.routine.isActive;
    _setupAnimations();
  }

  @override
  void didUpdateWidget(RoutineSummaryCardNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routine.isActive != widget.routine.isActive) {
      _isActive = widget.routine.isActive;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 애니메이션 설정
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: _isActive
                    ? Border.all(
                        color: widget.routine.concept.color.withOpacity(0.3),
                        width: 2,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 (제목, 즐겨찾기, 활성화 토글 등)
                  RoutineCardHeader(
                    routine: widget.routine,
                    isActive: _isActive,
                    onFavoriteToggle: widget.onToggleFavorite,
                    onActiveToggle: _toggleActive,
                    onMoreOptions: _showMoreOptions,
                  ),
                  
                  // 진행률 섹션
                  RoutineProgressSection(routine: widget.routine),
                  
                  // 루틴 항목 미리보기
                  RoutineItemsPreview(routine: widget.routine),
                  
                  const SizedBox(height: 12),
                  
                  // 푸터 (태그, 날짜 등)
                  RoutineCardFooter(routine: widget.routine),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 활성화 토글
  Future<void> _toggleActive() async {
    try {
      // 낙관적 업데이트
      setState(() {
        _isActive = !_isActive;
      });

      // 서버 업데이트
      await _routineRepository.toggleRoutineActive(widget.routine.id);
      
      // 햅틱 피드백
      HapticFeedback.lightImpact();
      
    } catch (e) {
      // 실패시 원래 상태로 복원
      setState(() {
        _isActive = !_isActive;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('루틴 활성화 상태 변경에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 더보기 옵션 메뉴
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // 메뉴 옵션들
            _buildMenuOption(
              icon: Icons.edit,
              title: '편집',
              onTap: _editRoutine,
            ),
            _buildMenuOption(
              icon: Icons.copy,
              title: '복사',
              onTap: _copyRoutine,
            ),
            _buildMenuOption(
              icon: Icons.share,
              title: '공유',
              onTap: _shareRoutine,
            ),
            const Divider(),
            _buildMenuOption(
              icon: Icons.delete,
              title: '삭제',
              color: Colors.red,
              onTap: _confirmDelete,
            ),
          ],
        ),
      ),
    );
  }

  /// 메뉴 옵션 위젯
  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  /// 루틴 편집
  void _editRoutine() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineEditScreen(routine: widget.routine),
      ),
    );
  }

  /// 루틴 복사
  void _copyRoutine() {
    // TODO: 루틴 복사 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('루틴이 복사되었습니다')),
    );
  }

  /// 루틴 공유
  void _shareRoutine() {
    final shareText = '''
${widget.routine.title}

${widget.routine.description}

활동 목록:
${widget.routine.items.map((item) => '• ${item.title}').join('\n')}

RoutineCraft에서 만든 루틴입니다.
''';

    Share.share(shareText, subject: widget.routine.title);
  }

  /// 삭제 확인
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 삭제'),
        content: Text('\'${widget.routine.title}\' 루틴을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}