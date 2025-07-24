import 'package:flutter/foundation.dart';
import '../../domain/entities/daily_routine.dart';
import '../../domain/entities/routine_concept.dart';
import '../../domain/repositories/routine_repository.dart';
import '../../domain/services/routine_limit_service.dart';
import '../../core/constants/routine_limits.dart';
import '../../di/service_locator.dart';

/// 루틴 목록 상태 관리 Provider
class RoutineListProvider with ChangeNotifier {
  final RoutineRepository _routineRepository = getIt<RoutineRepository>();
  
  // 루틴 데이터
  List<DailyRoutine> _allRoutines = [];
  List<DailyRoutine> _favoriteRoutines = [];
  List<DailyRoutine> _filteredAllRoutines = [];
  List<DailyRoutine> _filteredFavoriteRoutines = [];
  
  // 상태
  bool _isLoading = true;
  
  // 저장 공간 관련 상태
  int _currentCount = 0;
  int _remainingSlots = 0;
  LimitStatus _storageStatus = LimitStatus.available;
  UserTier _userTier = UserTier.free;

  // Getters
  List<DailyRoutine> get allRoutines => _allRoutines;
  List<DailyRoutine> get favoriteRoutines => _favoriteRoutines;
  List<DailyRoutine> get filteredAllRoutines => _filteredAllRoutines;
  List<DailyRoutine> get filteredFavoriteRoutines => _filteredFavoriteRoutines;
  bool get isLoading => _isLoading;
  int get currentCount => _currentCount;
  int get remainingSlots => _remainingSlots;
  LimitStatus get storageStatus => _storageStatus;
  UserTier get userTier => _userTier;

  /// 루틴 목록 로드
  Future<void> loadRoutines() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allRoutines = await _routineRepository.getAllRoutines();
      _favoriteRoutines = _allRoutines.where((routine) => routine.isFavorite).toList();
      
      // 초기에는 필터링되지 않은 전체 목록을 표시
      _filteredAllRoutines = List.from(_allRoutines);
      _filteredFavoriteRoutines = List.from(_favoriteRoutines);
      
      await _updateStorageStatus();
    } catch (e) {
      debugPrint('루틴 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite(String routineId) async {
    try {
      final routine = _allRoutines.firstWhere((r) => r.id == routineId);
      final updatedRoutine = routine.copyWith(isFavorite: !routine.isFavorite);
      
      await _routineRepository.updateRoutine(updatedRoutine);
      
      // 로컬 상태 업데이트
      final index = _allRoutines.indexWhere((r) => r.id == routineId);
      if (index != -1) {
        _allRoutines[index] = updatedRoutine;
      }
      
      _favoriteRoutines = _allRoutines.where((routine) => routine.isFavorite).toList();
      _applyCurrentFilters();
      
      notifyListeners();
    } catch (e) {
      debugPrint('즐겨찾기 토글 실패: $e');
    }
  }

  /// 루틴 삭제
  Future<void> deleteRoutine(String routineId) async {
    try {
      await _routineRepository.deleteRoutine(routineId);
      
      _allRoutines.removeWhere((routine) => routine.id == routineId);
      _favoriteRoutines.removeWhere((routine) => routine.id == routineId);
      _applyCurrentFilters();
      
      await _updateStorageStatus();
      notifyListeners();
    } catch (e) {
      debugPrint('루틴 삭제 실패: $e');
    }
  }

  /// 모든 루틴 삭제
  Future<void> clearAllRoutines() async {
    try {
      for (final routine in _allRoutines) {
        await _routineRepository.deleteRoutine(routine.id);
      }
      
      _allRoutines.clear();
      _favoriteRoutines.clear();
      _filteredAllRoutines.clear();
      _filteredFavoriteRoutines.clear();
      
      await _updateStorageStatus();
      notifyListeners();
    } catch (e) {
      debugPrint('전체 루틴 삭제 실패: $e');
    }
  }

  /// 필터 적용
  void applyFilters(String searchQuery, Set<RoutineConcept> selectedConcepts) {
    _filteredAllRoutines = _filterRoutines(_allRoutines, searchQuery, selectedConcepts);
    _filteredFavoriteRoutines = _filterRoutines(_favoriteRoutines, searchQuery, selectedConcepts);
    notifyListeners();
  }

  /// 현재 필터 다시 적용
  void _applyCurrentFilters() {
    // 필터 상태는 별도 Provider에서 관리하므로 기본 필터만 적용
    _filteredAllRoutines = List.from(_allRoutines);
    _filteredFavoriteRoutines = List.from(_favoriteRoutines);
  }

  /// 루틴 필터링 로직
  List<DailyRoutine> _filterRoutines(
    List<DailyRoutine> routines,
    String searchQuery,
    Set<RoutineConcept> selectedConcepts,
  ) {
    return routines.where((routine) {
      // 검색어 필터
      bool matchesSearch = searchQuery.isEmpty ||
          routine.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          routine.description.toLowerCase().contains(searchQuery.toLowerCase());

      // 컨셉 필터
      bool matchesConcept = selectedConcepts.isEmpty ||
          selectedConcepts.contains(routine.concept);

      return matchesSearch && matchesConcept;
    }).toList();
  }

  /// 저장 공간 상태 업데이트
  Future<void> _updateStorageStatus() async {
    try {
      final routineLimitService = getIt<RoutineLimitService>();
      _currentCount = _allRoutines.length;
      _remainingSlots = await routineLimitService.getRemainingRoutineSlots();
      _storageStatus = await routineLimitService.getRoutineStorageStatus();
      _userTier = await routineLimitService.getCurrentUserTier();
    } catch (e) {
      debugPrint('저장 공간 상태 업데이트 실패: $e');
    }
  }
}