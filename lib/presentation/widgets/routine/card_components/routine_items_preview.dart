import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_routine.dart';
import '../../../../domain/entities/routine_item.dart';

/// 루틴 항목 미리보기 위젯
class RoutineItemsPreview extends StatelessWidget {
  final DailyRoutine routine;
  final int maxItems;

  const RoutineItemsPreview({
    super.key,
    required this.routine,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (routine.items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey[400],
            ),
            const SizedBox(width: 8),
            Text(
              '아직 추가된 활동이 없어요',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final itemsToShow = routine.items.take(maxItems).toList();
    final hasMoreItems = routine.items.length > maxItems;

    return Column(
      children: [
        const SizedBox(height: 12),
        
        // 루틴 항목들
        ...itemsToShow.map((item) => _buildRoutineItem(item)),
        
        // 더 많은 항목이 있을 때 표시
        if (hasMoreItems)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.more_horiz,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${routine.items.length - maxItems}개 더',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// 개별 루틴 항목 위젯
  Widget _buildRoutineItem(RoutineItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: item.isCompleted ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: item.isCompleted
            ? Border.all(color: Colors.green[200]!, width: 1)
            : null,
      ),
      child: Row(
        children: [
          // 완료 상태 아이콘
          Icon(
            item.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: item.isCompleted ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          
          // 항목 제목
          Expanded(
            child: Text(
              item.title,
              style: TextStyle(
                fontSize: 13,
                color: item.isCompleted ? Colors.green[700] : Colors.grey[700],
                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // 시간 표시 (있는 경우)
          if (item.scheduledTime != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${item.scheduledTime!.hour.toString().padLeft(2, '0')}:${item.scheduledTime!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}