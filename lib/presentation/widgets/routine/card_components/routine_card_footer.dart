import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_routine.dart';

/// 루틴 카드 푸터 위젯
class RoutineCardFooter extends StatelessWidget {
  final DailyRoutine routine;

  const RoutineCardFooter({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 컨셉 태그
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: routine.concept.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            routine.concept.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: routine.concept.color,
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 항목 개수
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${routine.items.length}개 활동',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ),
        
        const Spacer(),
        
        // 생성/수정 날짜
        Text(
          _formatDate(routine.updatedAt ?? routine.createdAt),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  /// 날짜 포맷팅
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '오늘';
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}