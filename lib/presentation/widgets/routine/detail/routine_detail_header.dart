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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            routine.concept.color.withValues(alpha: 0.08),
            routine.concept.color.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 행: 아이콘, 제목, 스위치
          Row(
            children: [
              // 컨셉 아이콘 (축소)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: routine.concept.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    routine.concept.displayName.split(' ')[0],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // 제목 (축소)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (routine.description.isNotEmpty)
                      Text(
                        routine.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              
              // 즐겨찾기와 활성화 스위치
              IconButton(
                icon: Icon(
                  routine.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: routine.isFavorite ? Colors.red : Colors.grey[400],
                  size: 20,
                ),
                onPressed: onToggleFavorite,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 상태 아이콘
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isActive ? Icons.notifications_active : Icons.notifications_off,
                      key: ValueKey(isActive),
                      size: 14,
                      color: isActive ? routine.concept.color : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isActive,
                      onChanged: (_) => onToggleActive?.call(),
                      activeColor: Colors.white,
                      activeTrackColor: routine.concept.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 하단 행: 컨셉 태그
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: routine.concept.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              routine.concept.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: routine.concept.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}