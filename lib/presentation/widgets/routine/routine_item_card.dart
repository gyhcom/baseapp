import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/routine_item.dart';

/// 루틴 아이템 카드 위젯
class RoutineItemCard extends StatefulWidget {
  final RoutineItem item;
  final VoidCallback onToggleComplete;
  final VoidCallback? onEdit;

  const RoutineItemCard({
    super.key,
    required this.item,
    required this.onToggleComplete,
    this.onEdit,
  });

  @override
  State<RoutineItemCard> createState() => _RoutineItemCardState();
}

class _RoutineItemCardState extends State<RoutineItemCard>
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
      duration: const Duration(milliseconds: 200),
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onToggleComplete();
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
          borderRadius: AppTheme.mediumRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: widget.item.isCompleted 
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.surfaceColor,
              borderRadius: AppTheme.mediumRadius,
              border: Border.all(
                color: widget.item.isCompleted 
                    ? AppTheme.primaryColor
                    : AppTheme.dividerColor,
                width: widget.item.isCompleted ? 2 : 1,
              ),
              boxShadow: widget.item.isCompleted 
                  ? [AppTheme.buttonShadow]
                  : [AppTheme.cardShadow],
            ),
            child: Row(
              children: [
                // 완료 체크박스
                _buildCheckbox(),
                
                const SizedBox(width: AppTheme.spacingM),
                
                // 시간 표시
                _buildTimeDisplay(),
                
                const SizedBox(width: AppTheme.spacingM),
                
                // 메인 콘텐츠
                Expanded(child: _buildMainContent()),
                
                // 우선순위 및 액션
                _buildTrailingActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: widget.item.isCompleted 
            ? AppTheme.primaryColor 
            : Colors.transparent,
        border: Border.all(
          color: widget.item.isCompleted 
              ? AppTheme.primaryColor 
              : AppTheme.dividerColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: widget.item.isCompleted
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }

  Widget _buildTimeDisplay() {
    final startTime = widget.item.startTime;
    final endTime = TimeOfDay(
      hour: (startTime.hour + widget.item.duration.inHours) % 24,
      minute: (startTime.minute + widget.item.duration.inMinutes % 60) % 60,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: widget.item.isCompleted
            ? AppTheme.primaryColor.withOpacity(0.2)
            : AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.item.isCompleted
              ? AppTheme.primaryColor.withOpacity(0.3)
              : AppTheme.accentColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            _formatTime(startTime),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: widget.item.isCompleted
                  ? AppTheme.primaryColor
                  : AppTheme.accentColor,
            ),
          ),
          Container(
            width: 20,
            height: 1,
            color: widget.item.isCompleted
                ? AppTheme.primaryColor.withOpacity(0.5)
                : AppTheme.accentColor.withOpacity(0.5),
            margin: const EdgeInsets.symmetric(vertical: 2),
          ),
          Text(
            _formatTime(endTime),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: widget.item.isCompleted
                  ? AppTheme.primaryColor.withOpacity(0.7)
                  : AppTheme.accentColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(
          widget.item.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            decoration: widget.item.isCompleted 
                ? TextDecoration.lineThrough 
                : null,
            color: widget.item.isCompleted
                ? AppTheme.textSecondaryColor
                : AppTheme.textPrimaryColor,
          ),
        ),
        
        if (widget.item.description.isNotEmpty) ...[ 
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            widget.item.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.item.isCompleted
                  ? AppTheme.textSecondaryColor.withOpacity(0.7)
                  : AppTheme.textSecondaryColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        
        const SizedBox(height: AppTheme.spacingS),
        
        // 메타 정보
        _buildMetaInfo(),
      ],
    );
  }

  Widget _buildMetaInfo() {
    return Wrap(
      spacing: AppTheme.spacingS,
      runSpacing: 4,
      children: [
        // 카테고리
        _buildMetaChip(
          widget.item.category,
          _getCategoryIcon(widget.item.category),
          _getCategoryColor(widget.item.category),
        ),
        
        // 소요 시간
        _buildMetaChip(
          _formatDuration(widget.item.duration),
          Icons.schedule,
          AppTheme.accentColor,
        ),
      ],
    );
  }

  Widget _buildMetaChip(String label, IconData icon, Color color) {
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
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailingActions() {
    return Column(
      children: [
        // 우선순위 표시
        _buildPriorityIndicator(),
        
        const SizedBox(height: AppTheme.spacingS),
        
        // 수정 버튼
        if (widget.onEdit != null)
          GestureDetector(
            onTap: widget.onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.dividerColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.edit,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriorityIndicator() {
    final color = _getPriorityColor(widget.item.priority);
    final icon = _getPriorityIcon(widget.item.priority);
    
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(
        icon,
        size: 14,
        color: color,
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '운동':
        return Icons.fitness_center;
      case '식사':
        return Icons.restaurant;
      case '업무':
        return Icons.work;
      case '여가':
        return Icons.weekend;
      case '건강':
        return Icons.health_and_safety;
      case '정신건강':
        return Icons.psychology;
      case '자기계발':
        return Icons.school;
      case '계획':
        return Icons.event_note;
      case '정리':
        return Icons.checklist;
      case '휴식':
        return Icons.bed;
      default:
        return Icons.circle;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '운동':
        return Colors.orange;
      case '식사':
        return Colors.green;
      case '업무':
        return Colors.blue;
      case '여가':
        return Colors.purple;
      case '건강':
        return Colors.red;
      case '정신건강':
        return Colors.indigo;
      case '자기계발':
        return Colors.teal;
      case '계획':
        return Colors.amber;
      case '정리':
        return Colors.cyan;
      case '휴식':
        return Colors.grey;
      default:
        return AppTheme.primaryColor;
    }
  }

  Color _getPriorityColor(RoutinePriority priority) {
    switch (priority) {
      case RoutinePriority.high:
        return Colors.red;
      case RoutinePriority.medium:
        return Colors.orange;
      case RoutinePriority.low:
        return Colors.green;
    }
  }

  IconData _getPriorityIcon(RoutinePriority priority) {
    switch (priority) {
      case RoutinePriority.high:
        return Icons.priority_high;
      case RoutinePriority.medium:
        return Icons.remove;
      case RoutinePriority.low:
        return Icons.keyboard_arrow_down;
    }
  }
}