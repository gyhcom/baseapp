import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/routine_search_provider.dart';

/// 루틴 검색바 위젯
class RoutineSearchBar extends StatelessWidget {
  const RoutineSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineSearchProvider>(
      builder: (context, searchProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: searchProvider.searchController,
            decoration: InputDecoration(
              hintText: '루틴 검색...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              suffixIcon: searchProvider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600]),
                      onPressed: searchProvider.clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}