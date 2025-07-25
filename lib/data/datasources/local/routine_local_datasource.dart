import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/entities/user_usage.dart';
import '../../../domain/entities/notification_settings.dart';
import '../../../domain/entities/user_auth.dart';
import '../../models/daily_routine_hive.dart';

/// 로컬 저장소 데이터 소스 (Hive 기반)
abstract class RoutineLocalDataSource {
  /// 루틴 저장
  Future<void> saveRoutine(DailyRoutine routine);
  
  /// 저장된 루틴 목록 조회
  Future<List<DailyRoutine>> getSavedRoutines();
  
  /// 특정 루틴 조회
  Future<DailyRoutine?> getRoutineById(String id);
  
  /// 루틴 삭제
  Future<void> deleteRoutine(String id);
  
  /// 즐겨찾기 토글
  Future<void> toggleFavorite(String id);
  
  /// 즐겨찾기 루틴만 조회
  Future<List<DailyRoutine>> getFavoriteRoutines();
  
  /// 사용자 프로필 저장
  Future<void> saveUserProfile(UserProfile profile);
  
  /// 사용자 프로필 조회
  Future<UserProfile?> getUserProfile();
  
  /// 로컬 데이터 초기화
  Future<void> clearAllData();
}

/// Hive 기반 로컬 데이터소스 구현
class RoutineLocalDataSourceImpl implements RoutineLocalDataSource {
  static const String _routineBoxName = 'routines';
  static const String _profileBoxName = 'profile';
  
  late Box<DailyRoutineHive> _routineBox;
  late Box<UserProfileHive> _profileBox;
  
  /// 초기화
  Future<void> init() async {
    await Hive.initFlutter();
    
    // 스키마 변경으로 인한 기존 박스 삭제 (임시)
    try {
      if (await Hive.boxExists(_routineBoxName)) {
        print('🗑️ 기존 루틴 박스 삭제 중...');
        await Hive.deleteBoxFromDisk(_routineBoxName);
        print('✅ 기존 루틴 박스 삭제 완료');
      }
    } catch (e) {
      print('⚠️ 기존 박스 삭제 실패 (계속 진행): $e');
    }
    
    // 어댑터 등록
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DailyRoutineHiveAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(RoutineItemHiveAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserProfileHiveAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(UserUsageAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(BonusEarnedAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(BonusTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(NotificationSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(UserAuthAdapter());
    }
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(UserAuthProviderAdapter());
    }
    
    // 박스 열기
    _routineBox = await Hive.openBox<DailyRoutineHive>(_routineBoxName);
    _profileBox = await Hive.openBox<UserProfileHive>(_profileBoxName);
  }

  @override
  Future<void> saveRoutine(DailyRoutine routine) async {
    final hiveRoutine = DailyRoutineHive.fromDailyRoutine(routine);
    await _routineBox.put(routine.id, hiveRoutine);
  }

  @override
  Future<List<DailyRoutine>> getSavedRoutines() async {
    final routinesData = _routineBox.values.toList();
    
    return routinesData
        .map((hiveRoutine) => hiveRoutine.toDailyRoutine())
        .toList()
        ..sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);
  }

  @override
  Future<DailyRoutine?> getRoutineById(String id) async {
    final hiveRoutine = _routineBox.get(id);
    if (hiveRoutine == null) return null;
    
    return hiveRoutine.toDailyRoutine();
  }

  @override
  Future<void> deleteRoutine(String id) async {
    await _routineBox.delete(id);
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final hiveRoutine = _routineBox.get(id);
    if (hiveRoutine == null) return;
    
    final routine = hiveRoutine.toDailyRoutine();
    final updatedRoutine = routine.copyWith(isFavorite: !routine.isFavorite);
    await saveRoutine(updatedRoutine);
  }

  @override
  Future<List<DailyRoutine>> getFavoriteRoutines() async {
    final allRoutines = await getSavedRoutines();
    return allRoutines.where((routine) => routine.isFavorite).toList();
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final hiveProfile = UserProfileHive.fromUserProfile(profile);
    await _profileBox.put('current_user', hiveProfile);
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    final hiveProfile = _profileBox.get('current_user');
    if (hiveProfile == null) return null;
    
    return hiveProfile.toUserProfile();
  }

  @override
  Future<void> clearAllData() async {
    await _routineBox.clear();
    await _profileBox.clear();
  }
}