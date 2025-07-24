import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/daily_routine.dart';
import '../../../providers/routine_list_provider.dart';
import '../../../providers/routine_search_provider.dart';
import '../routine_summary_card.dart';
import '../empty_state_widget.dart';

/// 전체 루틴 탭
class AllRoutinesTab extends StatelessWidget {
  final VoidCallback onCreateRoutine;
  final Function(DailyRoutine) onRoutineDetail;

  const AllRoutinesTab({
    super.key,
    required this.onCreateRoutine,
    required this.onRoutineDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoutineListProvider, RoutineSearchProvider>(
      builder: (context, routineProvider, searchProvider, child) {
        final routines = routineProvider.filteredAllRoutines;

        if (routines.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.schedule_outlined,
            title: '아직 루틴이 없어요',
            subtitle: '나만의 루틴을 만들어\n더 나은 하루를 시작해보세요!',
            buttonText: '루틴 만들기',
            onButtonPressed: onCreateRoutine,
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