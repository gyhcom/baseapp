import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_routine.dart';

/// 루틴 상세 헤더 위젯
class RoutineDetailHeader extends StatelessWidget {
  final DailyRoutine routine;
  final bool isActive;
  final VoidCallback? onToggleActive;
  final VoidCallback? onToggleFavorite;

  const RoutineDetailHeader({
    super.key,
    required this.routine,
    required this.isActive,
    this.onToggleActive,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            routine.concept.color.withOpacity(0.1),
            routine.concept.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 컨셉 아이콘과 활성화 토글
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: routine.concept.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  routine.concept.icon,
                  color: routine.concept.color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Switch(
                value: isActive,
                onChanged: (_) => onToggleActive?.call(),
                activeColor: Colors.white,
                activeTrackColor: routine.concept.color,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 제목
          Text(
            routine.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 설명
          if (routine.description.isNotEmpty)
            Text(
              routine.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          
          const SizedBox(height: 16),
          
          // 컨셉과 즐겨찾기
          Row(
            children: [
              // 컨셉 태그
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: routine.concept.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  routine.concept.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: routine.concept.color,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // 즐겨찾기 버튼
              IconButton(
                icon: Icon(
                  routine.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: routine.isFavorite ? Colors.red : Colors.grey[400],
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }
}