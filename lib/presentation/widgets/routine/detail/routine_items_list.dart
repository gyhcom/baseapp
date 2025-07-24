import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_routine.dart';
import '../../../../domain/entities/routine_item.dart';

/// 루틴 항목 목록 위젯
class RoutineItemsList extends StatelessWidget {
  final DailyRoutine routine;
  final Function(String) onToggleCompletion;
  final Function(RoutineItem) onEditItem;

  const RoutineItemsList({
    super.key,
    required this.routine,
    required this.onToggleCompletion,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    if (routine.items.isEmpty) {
      return _buildEmptyState();
    }

    // 시간별로 그룹화
    final timeGroups = _groupItemsByTime(routine.items);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.checklist,
                  color: routine.concept.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '활동 목록',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  '${routine.items.length}개',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // 항목 목록
          ...timeGroups.entries.map((entry) => _buildTimeGroup(
            entry.key,
            entry.value,
          )),
        ],
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.checklist_rtl,
            size: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            '아직 추가된 활동이 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '편집을 통해 활동을 추가해보세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 시간별 그룹 위젯
  Widget _buildTimeGroup(String timeLabel, List<RoutineItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 시간 라벨
        if (timeLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              timeLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: routine.concept.color,
              ),
            ),
          ),
        
        // 항목들
        ...items.map((item) => _buildRoutineItem(item)),
      ],
    );
  }

  /// 개별 루틴 항목 위젯
  Widget _buildRoutineItem(RoutineItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: item.isCompleted ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: item.isCompleted
            ? Border.all(color: Colors.green[200]!, width: 1)
            : null,
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () => onToggleCompletion(item.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: item.isCompleted ? Colors.green : Colors.transparent,
              border: item.isCompleted
                  ? null
                  : Border.all(color: Colors.grey[400]!, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.isCompleted
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: item.isCompleted ? Colors.green[700] : Colors.black87,
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: item.description.isNotEmpty
            ? Text(
                item.description,
                style: TextStyle(
                  fontSize: 13,
                  color: item.isCompleted ? Colors.green[600] : Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 예정 시간 표시
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${item.startTime.hour.toString().padLeft(2, '0')}:${item.startTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            
            // 편집 버튼
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey[600],
              ),
              onPressed: () => onEditItem(item),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
        onTap: () => onToggleCompletion(item.id),
      ),
    );
  }

  /// 시간별로 항목 그룹화
  Map<String, List<RoutineItem>> _groupItemsByTime(List<RoutineItem> items) {
    final groups = <String, List<RoutineItem>>{};
    
    for (final item in items) {
      String timeLabel = '';
      
      final hour = item.startTime.hour;
      if (hour >= 5 && hour < 12) {
        timeLabel = '🌅 오전';
      } else if (hour >= 12 && hour < 18) {
        timeLabel = '☀️ 오후';
      } else if (hour >= 18 && hour < 22) {
        timeLabel = '🌆 저녁';
      } else {
        timeLabel = '🌙 밤';
      }
      
      groups[timeLabel] = groups[timeLabel] ?? [];
      groups[timeLabel]!.add(item);
    }
    
    // 시간순으로 정렬
    final sortedEntries = groups.entries.toList()
      ..sort((a, b) {
        const order = ['🌅 오전', '☀️ 오후', '🌆 저녁', '🌙 밤', '📝 언제든지'];
        return order.indexOf(a.key).compareTo(order.indexOf(b.key));
      });
    
    return Map.fromEntries(sortedEntries);
  }
}