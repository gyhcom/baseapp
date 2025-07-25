import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/daily_routine.dart';
import '../../../providers/routine_list_provider.dart';
import '../../../providers/routine_search_provider.dart';
import '../routine_summary_card.dart';
import '../empty_state_widget.dart';

/// 즐겨찾기 루틴 탭
class FavoriteRoutinesTab extends StatelessWidget {
  final VoidCallback onSwitchToAllTab;
  final Function(DailyRoutine) onRoutineDetail;

  const FavoriteRoutinesTab({
    super.key,
    required this.onSwitchToAllTab,
    required this.onRoutineDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoutineListProvider, RoutineSearchProvider>(
      builder: (context, routineProvider, searchProvider, child) {
        final routines = routineProvider.filteredFavoriteRoutines;

        if (routines.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.favorite_outline,
            title: searchProvider.hasActiveFilters
                ? '검색 결과가 없어요'
                : '즐겨찾기한 루틴이 없어요',
            subtitle: searchProvider.hasActiveFilters
                ? '다른 검색어나 필터를 시도해보세요'
                : '자주 사용하는 루틴을\n즐겨찾기에 추가해보세요!',
            buttonText: searchProvider.hasActiveFilters ? '필터 초기화' : '전체 루틴 보기',
            onButtonPressed: searchProvider.hasActiveFilters
                ? searchProvider.clearFilters
                : onSwitchToAllTab,
          );
        }

        return RefreshIndicator(
          onRefresh: routineProvider.loadRoutines,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RoutineSummaryCard(
                  routine: routine,
                  onTap: () => onRoutineDetail(routine),
                  onFavoriteToggle: () => routineProvider.toggleFavorite(routine.id),
                  onDelete: () => _showDeleteDialog(context, routine, routineProvider),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 삭제 확인 다이얼로그
  void _showDeleteDialog(
    BuildContext context,
    DailyRoutine routine,
    RoutineListProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 삭제'),
        content: Text('\'${routine.title}\' 루틴을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.deleteRoutine(routine.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}