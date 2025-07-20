import '../../domain/repositories/routine_repository.dart';
import '../../domain/entities/daily_routine.dart';
import '../../domain/entities/user_profile.dart';
import '../datasources/local/routine_local_datasource.dart';

/// 루틴 저장소 구현
class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource _localDataSource;

  const RoutineRepositoryImpl({
    required RoutineLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<void> saveRoutine(DailyRoutine routine) async {
    await _localDataSource.saveRoutine(routine);
  }

  @override
  Future<List<DailyRoutine>> getSavedRoutines() async {
    return await _localDataSource.getSavedRoutines();
  }

  @override
  Future<DailyRoutine?> getRoutineById(String id) async {
    return await _localDataSource.getRoutineById(id);
  }

  @override
  Future<void> deleteRoutine(String id) async {
    await _localDataSource.deleteRoutine(id);
  }

  @override
  Future<void> toggleFavorite(String id) async {
    await _localDataSource.toggleFavorite(id);
  }

  @override
  Future<List<DailyRoutine>> getFavoriteRoutines() async {
    return await _localDataSource.getFavoriteRoutines();
  }

  @override
  Future<void> updateRoutine(DailyRoutine routine) async {
    // 수정된 시간으로 업데이트
    final updatedRoutine = routine.copyWith(
      createdAt: routine.createdAt ?? DateTime.now(),
    );
    await _localDataSource.saveRoutine(updatedRoutine);
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    await _localDataSource.saveUserProfile(profile);
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    return await _localDataSource.getUserProfile();
  }

  @override
  Future<void> incrementUsageCount(String id) async {
    final routine = await getRoutineById(id);
    if (routine != null) {
      final updatedRoutine = routine.copyWith(
        usageCount: routine.usageCount + 1,
      );
      await updateRoutine(updatedRoutine);
    }
  }

  @override
  Future<void> clearAllData() async {
    await _localDataSource.clearAllData();
  }
}