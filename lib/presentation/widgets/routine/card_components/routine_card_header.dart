import 'package:flutter/material.dart';
import '../../../../domain/entities/daily_routine.dart';
import '../../../../domain/entities/routine_concept.dart';

/// 루틴 카드 헤더 위젯
class RoutineCardHeader extends StatelessWidget {
  final DailyRoutine routine;
  final bool isActive;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onActiveToggle;
  final VoidCallback? onMoreOptions;

  const RoutineCardHeader({
    super.key,
    required this.routine,
    required this.isActive,
    this.onFavoriteToggle,
    this.onActiveToggle,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 컨셉 아이콘
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: routine.concept.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            routine.concept.displayName.split(' ')[0], // 이모지 부분만 추출
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 12),
        
        // 제목과 설명
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                routine.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (routine.description.isNotEmpty) ...[
                const SizedBox(height: 2),
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
            ],
          ),
        ),
        
        // 활성화 토글 (향상된 피드백)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상태 아이콘
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? Icons.notifications_active : Icons.notifications_off,
                key: ValueKey(isActive),
                size: 16,
                color: isActive ? routine.concept.color : Colors.grey[400],
              ),
            ),
            const SizedBox(width: 6),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: isActive,
                onChanged: (_) => onActiveToggle?.call(),
                activeColor: Colors.white,
                activeTrackColor: routine.concept.color,
                inactiveThumbColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[300],
              ),
            ),
          ],
        ),
        
        // 즐겨찾기 버튼
        IconButton(
          icon: Icon(
            routine.isFavorite ? Icons.favorite : Icons.favorite_outline,
            color: routine.isFavorite ? Colors.red : Colors.grey[400],
            size: 20,
          ),
          onPressed: onFavoriteToggle,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
        
        // 더보기 버튼
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey[400],
            size: 20,
          ),
          onPressed: onMoreOptions,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ],
    );
  }
}