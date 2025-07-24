import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_routine.dart';

/// 루틴 진행률 섹션 위젯
class RoutineProgressSection extends StatelessWidget {
  final DailyRoutine routine;

  const RoutineProgressSection({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = routine.items.where((item) => item.isCompleted).length;
    final totalCount = routine.items.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Column(
      children: [
        const SizedBox(height: 12),
        
        // 진행률 바
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(routine.concept.color),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$completedCount/$totalCount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 진행률 텍스트
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '오늘의 진행률',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: routine.concept.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}