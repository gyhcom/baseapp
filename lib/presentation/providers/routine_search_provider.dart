import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/routine_concept.dart';

/// 루틴 검색 및 필터링 상태 관리 Provider
class RoutineSearchProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  
  // 검색 상태
  bool _isSearching = false;
  String _searchQuery = '';
  Set<RoutineConcept> _selectedConcepts = {};

  // Getters
  TextEditingController get searchController => _searchController;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  Set<RoutineConcept> get selectedConcepts => _selectedConcepts;
  bool get hasActiveFilters => _searchQuery.isNotEmpty || _selectedConcepts.isNotEmpty;

  RoutineSearchProvider() {
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 검색 모드 토글
  void toggleSearch() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      clearSearch();
    }
    notifyListeners();
  }

  /// 검색어 변경 처리
  void _onSearchChanged() {
    _searchQuery = _searchController.text;
    notifyListeners();
  }

  /// 검색 초기화
  void clearSearch() {
    _searchController.clear();
    _searchQuery = '';
    notifyListeners();
  }

  /// 컨셉 필터 토글
  void toggleConceptFilter(RoutineConcept concept) {
    if (_selectedConcepts.contains(concept)) {
      _selectedConcepts.remove(concept);
    } else {
      _selectedConcepts.add(concept);
    }
    notifyListeners();
  }

  /// 컨셉 필터 초기화
  void clearConceptFilters() {
    _selectedConcepts.clear();
    notifyListeners();
  }

  /// 모든 필터 초기화
  void clearFilters() {
    clearSearch();
    clearConceptFilters();
  }

  /// 특정 컨셉이 선택되었는지 확인
  bool isConceptSelected(RoutineConcept concept) {
    return _selectedConcepts.contains(concept);
  }
}