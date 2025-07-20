import '../entities/daily_routine.dart';
import '../entities/user_profile.dart';

/// 루틴 저장소 인터페이스
abstract class RoutineRepository {
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
  
  /// 루틴 업데이트 (완료상태, 수정 등)
  Future<void> updateRoutine(DailyRoutine routine);
  
  /// 사용자 프로필 저장
  Future<void> saveUserProfile(UserProfile profile);
  
  /// 사용자 프로필 조회
  Future<UserProfile?> getUserProfile();
  
  /// 루틴 사용 횟수 증가
  Future<void> incrementUsageCount(String id);
  
  /// 모든 데이터 초기화
  Future<void> clearAllData();
}