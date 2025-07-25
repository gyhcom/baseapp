import '../../domain/repositories/routine_repository.dart';
import '../../domain/entities/daily_routine.dart';
import '../../domain/entities/user_profile.dart';
import '../datasources/local/routine_local_datasource.dart';
import '../../presentation/screens/routine/routine_notification_helper.dart';

/// 루틴 저장소 구현
class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource _localDataSource;

  const RoutineRepositoryImpl({
    required RoutineLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<void> saveRoutine(DailyRoutine routine) async {
    await _localDataSource.saveRoutine(routine);
    
    // 활성화된 루틴인 경우 알림 예약
    if (routine.isActive) {
      await RoutineNotificationHelper.scheduleNotificationsForRoutine(routine);
    }
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
    // 삭제 시 알림도 함께 취소
    await RoutineNotificationHelper.cancelNotificationsForRoutine(id);
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
    print('💾 updateRoutine 시작: ${routine.title} (활성화: ${routine.isActive})');
    
    // 수정된 시간으로 업데이트
    final updatedRoutine = routine.copyWith(
      createdAt: routine.createdAt ?? DateTime.now(),
    );
    
    print('💾 DB에 저장할 루틴 상태: ${updatedRoutine.isActive}');
    await _localDataSource.saveRoutine(updatedRoutine);
    print('✅ DB 저장 완료');
    
    // 기존 알림 취소 후 활성화된 경우 새로 예약
    print('🔔 알림 관리 시작...');
    await RoutineNotificationHelper.cancelNotificationsForRoutine(updatedRoutine.id);
    
    if (updatedRoutine.isActive) {
      print('🔔 활성화 상태이므로 알림 예약');
      
      // 저장 전 상태 확인
      final beforeAlarmRoutine = await getRoutineById(updatedRoutine.id);
      print('📊 알림 예약 전 DB 상태: ${beforeAlarmRoutine?.isActive}');
      
      await RoutineNotificationHelper.scheduleNotificationsForRoutine(updatedRoutine);
      
      // 저장 후 상태 확인
      final afterAlarmRoutine = await getRoutineById(updatedRoutine.id);
      print('📊 알림 예약 후 DB 상태: ${afterAlarmRoutine?.isActive}');
      
      // 만약 상태가 변경되었다면 다시 복원
      if (afterAlarmRoutine?.isActive == false) {
        print('⚠️ 알림 예약 후 상태가 비활성화됨! 다시 복원 중...');
        final restoredRoutine = updatedRoutine.copyWith(isActive: true);
        print('🔧 복원할 루틴 상태: ${restoredRoutine.isActive}');
        await _localDataSource.saveRoutine(restoredRoutine);
        print('✅ 루틴 상태 복원 완료');
        
        // 복원 후 다시 확인
        final finalCheckRoutine = await getRoutineById(updatedRoutine.id);
        print('🔍 복원 후 실제 상태: ${finalCheckRoutine?.isActive}');
      }
    } else {
      print('🔕 비활성화 상태이므로 알림 예약 건너뛰기');
    }
    
    print('✅ updateRoutine 완료');
    
    // 저장 후 실제 상태 확인
    final savedRoutine = await getRoutineById(updatedRoutine.id);
    print('🔍 저장 후 실제 DB 상태: ${savedRoutine?.isActive}');
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
  Future<void> toggleRoutineActive(String id) async {
    print('🔄 toggleRoutineActive 시작: $id');
    final routine = await getRoutineById(id);
    if (routine != null) {
      print('📊 DB에서 읽은 현재 상태: ${routine.isActive} (${routine.title})');
      print('📊 변경 예정 상태: ${!routine.isActive}');
      final updatedRoutine = routine.copyWith(
        isActive: !routine.isActive,
      );
      print('📊 업데이트할 루틴 상태: ${updatedRoutine.isActive}');
      
      // 먼저 루틴 상태 업데이트
      print('💾 루틴 상태 업데이트 중: ${updatedRoutine.isActive}');
      await updateRoutine(updatedRoutine);
      print('✅ 루틴 상태 업데이트 완료');
      
      // 그 다음 알림 관리 (updateRoutine에서 이미 처리하지만 확실히 하기 위해)
      if (updatedRoutine.isActive) {
        // 활성화 시 추가 알림 예약 확인
        print('🔔 활성화 완료 - 알림 상태 확인');
      } else {
        // 비활성화 시 추가 알림 취소 확인  
        print('🔕 비활성화 완료 - 알림 취소 확인');
      }
      
      print('✅ toggleRoutineActive 완료');
    } else {
      print('❌ 루틴을 찾을 수 없음: $id');
    }
  }

  @override
  Future<List<DailyRoutine>> getActiveRoutines() async {
    final allRoutines = await getSavedRoutines();
    return allRoutines.where((routine) => routine.isActive).toList();
  }

  @override
  Future<void> deactivateAllRoutines({String? exceptRoutineId}) async {
    print('🔧 deactivateAllRoutines 시작 (제외할 루틴: $exceptRoutineId)');
    final allRoutines = await getSavedRoutines();
    
    for (final routine in allRoutines) {
      print('📊 루틴 체크: ${routine.title} (ID: ${routine.id}, 활성화: ${routine.isActive})');
      
      if (routine.isActive && routine.id != exceptRoutineId) {
        print('🔧 루틴 비활성화: ${routine.title} (ID: ${routine.id})');
        final deactivatedRoutine = routine.copyWith(isActive: false);
        await updateRoutine(deactivatedRoutine);
      } else if (routine.id == exceptRoutineId) {
        print('⚠️ 제외된 루틴 건너뛰기: ${routine.title}');
      } else if (!routine.isActive) {
        print('ℹ️ 이미 비활성화된 루틴: ${routine.title}');
      }
    }
    
    print('✅ deactivateAllRoutines 완료');
  }

  @override
  Future<void> clearAllData() async {
    await _localDataSource.clearAllData();
  }

  /// Hive 스키마 변경으로 인한 임시 데이터 초기화
  Future<void> migrateHiveData() async {
    try {
      print('🔄 Hive 데이터 마이그레이션 시작...');
      await _localDataSource.clearAllData();
      print('✅ Hive 데이터 마이그레이션 완료');
    } catch (e) {
      print('❌ Hive 데이터 마이그레이션 실패: $e');
    }
  }
}