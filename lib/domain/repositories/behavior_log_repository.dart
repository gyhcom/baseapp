import '../entities/user_behavior_log.dart';

/// 행동 로그 저장소
abstract class BehaviorLogRepository {
  /// 행동 로그 저장
  Future<void> saveBehaviorLog(UserBehaviorLog log);
  
  /// 사용자별 행동 로그 조회
  Future<List<UserBehaviorLog>> getBehaviorLogs({
    required String userId,
    String? routineId,
    DateTime? since,
    DateTime? until,
    List<BehaviorType>? behaviors,
    int? limit,
  });
  
  /// 특정 루틴의 행동 로그 조회
  Future<List<UserBehaviorLog>> getRoutineBehaviorLogs({
    required String routineId,
    DateTime? since,
    int? limit,
  });
  
  /// 행동 패턴 저장 (캐시)
  Future<void> saveBehaviorPattern(BehaviorPattern pattern);
  
  /// 행동 패턴 조회 (캐시)
  Future<BehaviorPattern?> getBehaviorPattern({
    required String userId,
    required String routineId,
  });
  
  /// 오래된 로그 정리 (성능 최적화)
  Future<void> cleanupOldLogs({int keepDays = 90});
  
  /// 전체 로그 삭제
  Future<void> clearAllLogs();
}