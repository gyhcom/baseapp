import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_routine.dart';

/// 루틴 진행 요약 위젯
class RoutineProgressSummary extends StatelessWidget {
  final DailyRoutine routine;
  final double progress;
  final int completedCount;
  final int totalCount;

  const RoutineProgressSummary({
    super.key,
    required this.routine,
    required this.progress,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 원형 진행률 (축소)
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(routine.concept.color),
                ),
                Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: routine.concept.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 진행 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: routine.concept.color,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$completedCount / $totalCount 완료',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // 진행률 바 (컴팩트)
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(routine.concept.color),
                    minHeight: 4,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // 상태 메시지 (컴팩트)
                Text(
                  totalCount - completedCount == 0
                      ? '모든 활동 완료! 🎉'
                      : '${totalCount - completedCount}개 남음',
                  style: TextStyle(
                    fontSize: 12,
                    color: totalCount - completedCount == 0 
                        ? Colors.green[600] 
                        : Colors.grey[600],
                    fontWeight: totalCount - completedCount == 0 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}