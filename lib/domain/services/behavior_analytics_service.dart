import '../entities/user_behavior_log.dart';
import '../entities/daily_routine.dart';
import '../repositories/behavior_log_repository.dart';

/// 사용자 행동 패턴 분석 서비스
class BehaviorAnalyticsService {
  final BehaviorLogRepository _logRepository;
  
  const BehaviorAnalyticsService({
    required BehaviorLogRepository logRepository,
  }) : _logRepository = logRepository;

  /// 행동 로그 기록
  Future<void> logBehavior({
    required String userId,
    required String routineId, 
    required String routineItemId,
    required BehaviorType behaviorType,
    DateTime? notificationSentAt,
    Map<String, dynamic>? metadata,
  }) async {
    final now = DateTime.now();
    
    final log = UserBehaviorLog(
      id: 'log_${now.millisecondsSinceEpoch}',
      userId: userId,
      routineId: routineId,
      routineItemId: routineItemId,
      behaviorType: behaviorType,
      timestamp: now,
      dayOfWeek: now.weekday,
      hourOfDay: now.hour,
      notificationSentAt: notificationSentAt,
      responseDelay: notificationSentAt != null 
          ? now.difference(notificationSentAt) 
          : null,
      metadata: metadata,
    );
    
    await _logRepository.saveBehaviorLog(log);
  }

  /// 패턴 분석 및 업데이트
  Future<BehaviorPattern> analyzeBehaviorPattern({
    required String userId,
    required String routineId,
    int analysisPeriodDays = 30,
  }) async {
    final logs = await _logRepository.getBehaviorLogs(
      userId: userId,
      routineId: routineId,
      since: DateTime.now().subtract(Duration(days: analysisPeriodDays)),
    );

    if (logs.isEmpty) {
      return _createDefaultPattern(userId, routineId);
    }

    // 1. 시간별 성공률 분석
    final hourlySuccessRate = _analyzeHourlyPattern(logs);
    
    // 2. 요일별 성공률 분석  
    final weeklySuccessRate = _analyzeWeeklyPattern(logs);
    
    // 3. 알림 효과성 분석
    final notificationStats = _analyzeNotificationEffectiveness(logs);
    
    // 4. 연속성 분석
    final streakStats = _analyzeStreakPattern(logs);
    
    // 5. 최적 시간 추천
    final suggestedTimes = _generateOptimalTimes(
      hourlySuccessRate, 
      weeklySuccessRate,
    );

    return BehaviorPattern(
      userId: userId,
      routineId: routineId,
      hourlySuccessRate: hourlySuccessRate,
      weeklySuccessRate: weeklySuccessRate,
      averageResponseTime: notificationStats.averageResponseTime,
      notificationEffectiveness: notificationStats.effectiveness,
      currentStreak: streakStats.currentStreak,
      longestStreak: streakStats.longestStreak,
      overallSuccessRate: streakStats.overallSuccessRate,
      suggestedTimes: suggestedTimes,
      lastUpdated: DateTime.now(),
      totalDataPoints: logs.length,
    );
  }

  /// 시간별 패턴 분석 (0-23시)
  Map<int, double> _analyzeHourlyPattern(List<UserBehaviorLog> logs) {
    final hourlyStats = <int, _HourlyStats>{};
    
    // 시간별 시도/성공 횟수 집계
    for (final log in logs) {
      final hour = log.hourOfDay;
      hourlyStats[hour] ??= _HourlyStats();
      
      if (log.behaviorType == BehaviorType.routineStarted) {
        hourlyStats[hour]!.attempts++;
      } else if (log.behaviorType == BehaviorType.routineCompleted) {
        hourlyStats[hour]!.successes++;
      }
    }
    
    // 성공률 계산
    final result = <int, double>{};
    for (int hour = 0; hour < 24; hour++) {
      final stats = hourlyStats[hour];
      if (stats != null && stats.attempts > 0) {
        result[hour] = stats.successes / stats.attempts;
      } else {
        result[hour] = 0.0; // 데이터 없음
      }
    }
    
    return result;
  }

  /// 요일별 패턴 분석 (1=월, 7=일)
  Map<int, double> _analyzeWeeklyPattern(List<UserBehaviorLog> logs) {
    final weeklyStats = <int, _WeeklyStats>{};
    
    for (final log in logs) {
      final dayOfWeek = log.dayOfWeek;
      weeklyStats[dayOfWeek] ??= _WeeklyStats();
      
      if (log.behaviorType == BehaviorType.routineStarted) {
        weeklyStats[dayOfWeek]!.attempts++;
      } else if (log.behaviorType == BehaviorType.routineCompleted) {
        weeklyStats[dayOfWeek]!.successes++;
      }
    }
    
    final result = <int, double>{};
    for (int day = 1; day <= 7; day++) {
      final stats = weeklyStats[day];
      if (stats != null && stats.attempts > 0) {
        result[day] = stats.successes / stats.attempts;
      } else {
        result[day] = 0.0;
      }
    }
    
    return result;
  }

  /// 알림 효과성 분석
  _NotificationStats _analyzeNotificationEffectiveness(List<UserBehaviorLog> logs) {
    final notificationLogs = logs.where((log) => 
        log.notificationSentAt != null).toList();
    
    if (notificationLogs.isEmpty) {
      return _NotificationStats(
        effectiveness: 0.0,
        averageResponseTime: const Duration(hours: 1),
      );
    }
    
    int responses = 0;
    Duration totalResponseTime = Duration.zero;
    
    for (final log in notificationLogs) {
      if (log.behaviorType == BehaviorType.notificationResponded ||
          log.behaviorType == BehaviorType.routineCompleted) {
        responses++;
        if (log.responseDelay != null) {
          totalResponseTime += log.responseDelay!;
        }
      }
    }
    
    final effectiveness = responses / notificationLogs.length;
    final averageResponseTime = responses > 0 
        ? Duration(milliseconds: totalResponseTime.inMilliseconds ~/ responses)
        : const Duration(hours: 1);
    
    return _NotificationStats(
      effectiveness: effectiveness,
      averageResponseTime: averageResponseTime,
    );
  }

  /// 연속성 패턴 분석
  _StreakStats _analyzeStreakPattern(List<UserBehaviorLog> logs) {
    final completedLogs = logs
        .where((log) => log.behaviorType == BehaviorType.routineCompleted)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    if (completedLogs.isEmpty) {
      return _StreakStats(
        currentStreak: 0,
        longestStreak: 0,
        overallSuccessRate: 0.0,
      );
    }
    
    // 연속 성공 계산
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 1;
    DateTime? lastDate;
    
    for (final log in completedLogs) {
      final currentDate = DateTime(
        log.timestamp.year,
        log.timestamp.month, 
        log.timestamp.day,
      );
      
      if (lastDate != null) {
        final daysDiff = currentDate.difference(lastDate).inDays;
        if (daysDiff == 1) {
          tempStreak++;
        } else {
          longestStreak = longestStreak > tempStreak ? longestStreak : tempStreak;
          tempStreak = 1;
        }
      }
      
      lastDate = currentDate;
    }
    
    longestStreak = longestStreak > tempStreak ? longestStreak : tempStreak;
    
    // 현재 연속 성공 (최근 날짜부터 역산)
    final today = DateTime.now();
    final recentLogs = completedLogs.reversed.toList();
    
    for (int i = 0; i < recentLogs.length; i++) {
      final logDate = DateTime(
        recentLogs[i].timestamp.year,
        recentLogs[i].timestamp.month,
        recentLogs[i].timestamp.day,
      );
      final daysDiff = today.difference(logDate).inDays;
      
      if (daysDiff == i) {
        currentStreak++;
      } else {
        break;
      }
    }
    
    // 전체 성공률
    final totalAttempts = logs
        .where((log) => log.behaviorType == BehaviorType.routineStarted)
        .length;
    final overallSuccessRate = totalAttempts > 0 
        ? completedLogs.length / totalAttempts 
        : 0.0;
    
    return _StreakStats(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      overallSuccessRate: overallSuccessRate,
    );
  }

  /// 최적 시간 추천 생성
  List<OptimalTime> _generateOptimalTimes(
    Map<int, double> hourlySuccessRate,
    Map<int, double> weeklySuccessRate,
  ) {
    final suggestions = <OptimalTime>[];
    
    // 시간별 성공률 높은 상위 3개 시간대 추천
    final sortedHours = hourlySuccessRate.entries
        .where((entry) => entry.value > 0.3) // 30% 이상 성공률
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (int i = 0; i < 3 && i < sortedHours.length; i++) {
      final entry = sortedHours[i];
      
      // 가장 성공률 높은 요일 찾기
      final bestDay = weeklySuccessRate.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      
      suggestions.add(OptimalTime(
        dayOfWeek: bestDay.key,
        hour: entry.key,
        successProbability: entry.value * bestDay.value,
        reason: _generateRecommendationReason(entry.key, bestDay.key, entry.value),
      ));
    }
    
    return suggestions;
  }

  String _generateRecommendationReason(int hour, int dayOfWeek, double successRate) {
    final dayName = _getDayName(dayOfWeek);
    final timeSlot = _getTimeSlotName(hour);
    final percentage = (successRate * 100).round();
    
    return '$dayName $timeSlot에 ${percentage}% 성공률을 보여요';
  }
  
  String _getDayName(int dayOfWeek) {
    const days = ['', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return days[dayOfWeek];
  }
  
  String _getTimeSlotName(int hour) {
    if (hour < 6) return '새벽';
    if (hour < 12) return '오전';
    if (hour < 18) return '오후'; 
    return '저녁';
  }

  BehaviorPattern _createDefaultPattern(String userId, String routineId) {
    return BehaviorPattern(
      userId: userId,
      routineId: routineId,
      hourlySuccessRate: {for (int i = 0; i < 24; i++) i: 0.0},
      weeklySuccessRate: {for (int i = 1; i <= 7; i++) i: 0.0},
      averageResponseTime: const Duration(hours: 1),
      notificationEffectiveness: 0.0,
      currentStreak: 0,
      longestStreak: 0,
      overallSuccessRate: 0.0,
      suggestedTimes: [],
      lastUpdated: DateTime.now(),
      totalDataPoints: 0,
    );
  }
}

// 내부 헬퍼 클래스들
class _HourlyStats {
  int attempts = 0;
  int successes = 0;
}

class _WeeklyStats {
  int attempts = 0;
  int successes = 0;
}

class _NotificationStats {
  final double effectiveness;
  final Duration averageResponseTime;
  
  _NotificationStats({
    required this.effectiveness,
    required this.averageResponseTime,
  });
}

class _StreakStats {
  final int currentStreak;
  final int longestStreak;
  final double overallSuccessRate;
  
  _StreakStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.overallSuccessRate,
  });
}