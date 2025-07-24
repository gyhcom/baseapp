import 'package:flutter/foundation.dart';
import '../../domain/entities/daily_routine.dart';
import '../../domain/entities/routine_item.dart';
import '../../domain/repositories/routine_repository.dart';
import '../../di/service_locator.dart';

/// 루틴 상세 화면 상태 관리 Provider
class RoutineDetailProvider with ChangeNotifier {
  final RoutineRepository _routineRepository = getIt<RoutineRepository>();
  
  DailyRoutine _routine;
  bool _isLoading = false;
  bool _isActive;

  // Constructor
  RoutineDetailProvider(this._routine) : _isActive = _routine.isActive;

  // Getters
  DailyRoutine get routine => _routine;
  bool get isLoading => _isLoading;
  bool get isActive => _isActive;
  
  // 진행률 계산
  double get progress {
    if (_routine.items.isEmpty) return 0.0;
    final completedCount = _routine.items.where((item) => item.isCompleted).length;
    return completedCount / _routine.items.length;
  }
  
  int get completedCount => _routine.items.where((item) => item.isCompleted).length;
  int get totalCount => _routine.items.length;

  /// 루틴 새로고침
  Future<void> refreshRoutine() async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedRoutine = await _routineRepository.getRoutineById(_routine.id);
      if (updatedRoutine != null) {
        _routine = updatedRoutine;
        _isActive = updatedRoutine.isActive;
      }
    } catch (e) {
      debugPrint('루틴 새로고침 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 루틴 활성화 토글
  Future<void> toggleActive() async {
    try {
      // 낙관적 업데이트
      _isActive = !_isActive;
      notifyListeners();

      await _routineRepository.toggleRoutineActive(_routine.id);
      
      // 최신 상태로 업데이트
      await refreshRoutine();
    } catch (e) {
      // 실패시 원래 상태로 복원
      _isActive = !_isActive;
      notifyListeners();
      throw e;
    }
  }

  /// 루틴 항목 완료 토글
  Future<void> toggleItemCompletion(String itemId) async {
    try {
      final itemIndex = _routine.items.indexWhere((item) => item.id == itemId);
      if (itemIndex == -1) return;

      final updatedItem = _routine.items[itemIndex].copyWith(
        isCompleted: !_routine.items[itemIndex].isCompleted,
      );

      // 낙관적 업데이트
      final updatedItems = List<RoutineItem>.from(_routine.items);
      updatedItems[itemIndex] = updatedItem;
      _routine = _routine.copyWith(items: updatedItems);
      notifyListeners();

      // 서버 업데이트
      await _routineRepository.updateRoutine(_routine);
    } catch (e) {
      // 실패시 새로고침으로 원래 상태 복원
      await refreshRoutine();
      throw e;
    }
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite() async {
    try {
      final updatedRoutine = _routine.copyWith(isFavorite: !_routine.isFavorite);
      
      // 낙관적 업데이트
      _routine = updatedRoutine;
      notifyListeners();

      await _routineRepository.updateRoutine(updatedRoutine);
    } catch (e) {
      // 실패시 원래 상태로 복원
      _routine = _routine.copyWith(isFavorite: !_routine.isFavorite);
      notifyListeners();
      throw e;
    }
  }

  /// 루틴 삭제
  Future<void> deleteRoutine() async {
    try {
      await _routineRepository.deleteRoutine(_routine.id);
    } catch (e) {
      debugPrint('루틴 삭제 실패: $e');
      throw e;
    }
  }

  /// 루틴 업데이트 (편집 후)
  void updateRoutine(DailyRoutine updatedRoutine) {
    _routine = updatedRoutine;
    _isActive = updatedRoutine.isActive;
    notifyListeners();
  }
}