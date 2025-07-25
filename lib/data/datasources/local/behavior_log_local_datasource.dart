import 'package:hive/hive.dart';
import '../../../domain/entities/user_behavior_log.dart';
import 'package:flutter/foundation.dart';

/// 행동 로그 로컬 데이터소스
class BehaviorLogLocalDataSource {
  static const String _behaviorLogBoxName = 'behavior_logs';
  static const String _behaviorPatternBoxName = 'behavior_patterns';

  /// 행동 로그 저장
  Future<void> saveBehaviorLog(UserBehaviorLog log) async {
    final box = await Hive.openBox<Map>(_behaviorLogBoxName);
    await box.put(log.id, log.toJson());
  }

  /// 행동 로그 조회 (필터링 지원)
  Future<List<UserBehaviorLog>> getBehaviorLogs({
    required String userId,
    String? routineId,
    DateTime? since,
    DateTime? until,
    List<BehaviorType>? behaviors,
    int? limit,
  }) async {
    final box = await Hive.openBox<Map>(_behaviorLogBoxName);
    final allLogs = <UserBehaviorLog>[];
    
    for (final logData in box.values) {
      try {
        final log = UserBehaviorLog.fromJson(Map<String, dynamic>.from(logData));
        
        // 사용자 필터
        if (log.userId != userId) continue;
        
        // 루틴 필터
        if (routineId != null && log.routineId != routineId) continue;
        
        // 시간 범위 필터
        if (since != null && log.timestamp.isBefore(since)) continue;
        if (until != null && log.timestamp.isAfter(until)) continue;
        
        // 행동 타입 필터
        if (behaviors != null && !behaviors.contains(log.behaviorType)) continue;
        
        allLogs.add(log);
      } catch (e) {
        debugPrint('행동 로그 파싱 오류: $e');
        continue;
      }
    }
    
    // 시간순 정렬
    allLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // 제한 적용
    if (limit != null && allLogs.length > limit) {
      return allLogs.take(limit).toList();
    }
    
    return allLogs;
  }

  /// 루틴별 행동 로그 조회
  Future<List<UserBehaviorLog>> getRoutineBehaviorLogs({
    required String routineId,
    DateTime? since,
    int? limit,
  }) async {
    final box = await Hive.openBox<Map>(_behaviorLogBoxName);
    final routineLogs = <UserBehaviorLog>[];
    
    for (final logData in box.values) {
      try {
        final log = UserBehaviorLog.fromJson(Map<String, dynamic>.from(logData));
        
        if (log.routineId != routineId) continue;
        if (since != null && log.timestamp.isBefore(since)) continue;
        
        routineLogs.add(log);
      } catch (e) {
        debugPrint('루틴 로그 파싱 오류: $e');
        continue;
      }
    }
    
    routineLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    if (limit != null && routineLogs.length > limit) {
      return routineLogs.take(limit).toList();
    }
    
    return routineLogs;
  }

  /// 행동 패턴 저장 (분석 결과 캐시)
  Future<void> saveBehaviorPattern(BehaviorPattern pattern) async {
    final box = await Hive.openBox<Map>(_behaviorPatternBoxName);
    final key = '${pattern.userId}_${pattern.routineId}';
    await box.put(key, pattern.toJson());
  }

  /// 행동 패턴 조회 (캐시)
  Future<BehaviorPattern?> getBehaviorPattern({
    required String userId,
    required String routineId,
  }) async {
    final box = await Hive.openBox<Map>(_behaviorPatternBoxName);
    final key = '${userId}_$routineId';
    final patternData = box.get(key);
    
    if (patternData != null) {
      try {
        return BehaviorPattern.fromJson(Map<String, dynamic>.from(patternData));
      } catch (e) {
        debugPrint('패턴 데이터 파싱 오류: $e');
        return null;
      }
    }
    
    return null;
  }

  /// 오래된 로그 정리
  Future<void> cleanupOldLogs({int keepDays = 90}) async {
    final box = await Hive.openBox<Map>(_behaviorLogBoxName);
    final cutoffDate = DateTime.now().subtract(Duration(days: keepDays));
    final keysToDelete = <dynamic>[];
    
    for (final entry in box.toMap().entries) {
      try {
        final log = UserBehaviorLog.fromJson(Map<String, dynamic>.from(entry.value));
        if (log.timestamp.isBefore(cutoffDate)) {
          keysToDelete.add(entry.key);
        }
      } catch (e) {
        // 파싱 오류 시 해당 데이터 삭제
        keysToDelete.add(entry.key);
      }
    }
    
    for (final key in keysToDelete) {
      await box.delete(key);
    }
    
    debugPrint('${keysToDelete.length}개의 오래된 로그를 정리했습니다.');
  }

  /// 전체 로그 삭제
  Future<void> clearAllLogs() async {
    final logBox = await Hive.openBox<Map>(_behaviorLogBoxName);
    final patternBox = await Hive.openBox<Map>(_behaviorPatternBoxName);
    
    await logBox.clear();
    await patternBox.clear();
  }
  
  /// 통계 정보 조회
  Future<Map<String, int>> getLogStatistics() async {
    final box = await Hive.openBox<Map>(_behaviorLogBoxName);
    final stats = <String, int>{};
    
    for (final logData in box.values) {
      try {
        final log = UserBehaviorLog.fromJson(Map<String, dynamic>.from(logData));
        final behaviorType = log.behaviorType.toString();
        stats[behaviorType] = (stats[behaviorType] ?? 0) + 1;
      } catch (e) {
        continue;
      }
    }
    
    return stats;
  }
}