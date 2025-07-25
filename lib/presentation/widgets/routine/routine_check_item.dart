import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/routine_item.dart';

/// 루틴 아이템 체크리스트 위젯
/// 체크박스, 시간, 제목, 완료 상태 등을 표시
class RoutineCheckItem extends StatefulWidget {
  final RoutineItem item;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RoutineCheckItem({
    super.key,
    required this.item,
    required this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<RoutineCheckItem> createState() => _RoutineCheckItemState();
}

class _RoutineCheckItemState extends State<RoutineCheckItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onToggle();
  }

  Color get _priorityColor {
    switch (widget.item.priority) {
      case RoutinePriority.high:
        return Colors.red;
      case RoutinePriority.medium:
        return Colors.orange;
      case RoutinePriority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.item.isCompleted;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: _buildCard(isCompleted),
          ),
        );
      },
    );
  }

  Widget _buildCard(bool isCompleted) {
    return Card(
      elevation: isCompleted ? 2 : 4,
      color: isCompleted 
          ? AppTheme.surfaceColor.withValues(alpha: 0.8)
          : AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.mediumRadius,
        side: BorderSide(
          color: isCompleted 
              ? Colors.green.withValues(alpha: 0.5)
              : _priorityColor.withValues(alpha: 0.3),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: _handleTap,
        borderRadius: AppTheme.mediumRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // 체크박스
              _buildCheckbox(isCompleted),
              
              const SizedBox(width: AppTheme.spacingM),
              
              // 시간 표시
              _buildTimeDisplay(),
              
              const SizedBox(width: AppTheme.spacingM),
              
              // 메인 콘텐츠
              Expanded(
                child: _buildMainContent(isCompleted),
              ),
              
              // 액션 버튼들
              if (widget.onEdit != null || widget.onDelete != null)
                _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isCompleted) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? Colors.green : Colors.transparent,
          border: Border.all(
            color: isCompleted ? Colors.green : AppTheme.dividerColor,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: _priorityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _priorityColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.item.timeDisplay,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _priorityColor,
            ),
          ),
          Text(
            widget.item.durationDisplay,
            style: TextStyle(
              fontSize: 10,
              color: _priorityColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(
          widget.item.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted 
                ? AppTheme.textSecondaryColor 
                : AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        if (widget.item.description.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            widget.item.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted 
                  ? AppTheme.textSecondaryColor.withValues(alpha: 0.7)
                  : AppTheme.textSecondaryColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        
        // 카테고리와 태그
        if (widget.item.category.isNotEmpty || widget.item.tags.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Wrap(
            spacing: AppTheme.spacingXS,
            children: [
              // 카테고리
              if (widget.item.category.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingXS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.item.category,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              
              // 태그들
              ...widget.item.tags.take(2).map((tag) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.accentColor,
                  ),
                ),
              )),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppTheme.textSecondaryColor,
        size: 18,
      ),
      itemBuilder: (context) => [
        if (widget.onEdit != null)
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingS),
                const Text('수정'),
              ],
            ),
          ),
        if (widget.onDelete != null)
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete, size: 16, color: Colors.red),
                const SizedBox(width: AppTheme.spacingS),
                const Text('삭제', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            widget.onEdit?.call();
            break;
          case 'delete':
            widget.onDelete?.call();
            break;
        }
      },
    );
  }
}