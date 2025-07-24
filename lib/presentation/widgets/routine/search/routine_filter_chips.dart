import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/routine_concept.dart';
import '../../../providers/routine_search_provider.dart';

/// 루틴 필터 칩 위젯
class RoutineFilterChips extends StatelessWidget {
  const RoutineFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineSearchProvider>(
      builder: (context, searchProvider, child) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...RoutineConcept.values.map((concept) {
                      final isSelected = searchProvider.isConceptSelected(concept);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(concept.displayName),
                          selected: isSelected,
                          onSelected: (_) => searchProvider.toggleConceptFilter(concept),
                          backgroundColor: Colors.grey[100],
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              if (searchProvider.hasActiveFilters) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: searchProvider.clearFilters,
                  tooltip: '필터 초기화',
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}