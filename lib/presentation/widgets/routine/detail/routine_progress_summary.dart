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
      padding: const EdgeInsets.all(20),
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
          // 제목
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: routine.concept.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '오늘의 진행률',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 진행률 표시
          Row(
            children: [
              // 원형 진행률
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(routine.concept.color),
                    ),
                    Center(
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: routine.concept.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),
              
              // 진행 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$completedCount / $totalCount 완료',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalCount - completedCount == 0
                          ? '모든 활동을 완료했어요! 🎉'
                          : '${totalCount - completedCount}개 활동이 남았어요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 진행률 바
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(routine.concept.color),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 격려 메시지
          if (progress == 1.0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.celebration, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '오늘의 루틴을 모두 완료했습니다!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (progress >= 0.5)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '잘 하고 있어요! 이대로 계속해보세요.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
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