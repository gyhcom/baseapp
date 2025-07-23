import '../../domain/entities/user_behavior_log.dart';
import '../../domain/repositories/behavior_log_repository.dart';
import '../datasources/local/behavior_log_local_datasource.dart';

/// 행동 로그 저장소 구현
class BehaviorLogRepositoryImpl implements BehaviorLogRepository {
  final BehaviorLogLocalDataSource _localDataSource;
  
  const BehaviorLogRepositoryImpl({
    required BehaviorLogLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<void> saveBehaviorLog(UserBehaviorLog log) async {
    await _localDataSource.saveBehaviorLog(log);
  }

  @override
  Future<List<UserBehaviorLog>> getBehaviorLogs({
    required String userId,
    String? routineId,
    DateTime? since,
    DateTime? until,
    List<BehaviorType>? behaviors,
    int? limit,
  }) async {
    return await _localDataSource.getBehaviorLogs(
      userId: userId,
      routineId: routineId,
      since: since,
      until: until,
      behaviors: behaviors,
      limit: limit,
    );
  }

  @override
  Future<List<UserBehaviorLog>> getRoutineBehaviorLogs({
    required String routineId,
    DateTime? since,
    int? limit,
  }) async {
    return await _localDataSource.getRoutineBehaviorLogs(
      routineId: routineId,
      since: since,
      limit: limit,
    );
  }

  @override
  Future<void> saveBehaviorPattern(BehaviorPattern pattern) async {
    await _localDataSource.saveBehaviorPattern(pattern);
  }

  @override
  Future<BehaviorPattern?> getBehaviorPattern({
    required String userId,
    required String routineId,
  }) async {
    return await _localDataSource.getBehaviorPattern(
      userId: userId,
      routineId: routineId,
    );
  }

  @override
  Future<void> cleanupOldLogs({int keepDays = 90}) async {
    await _localDataSource.cleanupOldLogs(keepDays: keepDays);
  }

  @override
  Future<void> clearAllLogs() async {
    await _localDataSource.clearAllLogs();
  }
}