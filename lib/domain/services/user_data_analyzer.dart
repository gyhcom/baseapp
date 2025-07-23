import '../entities/user_behavior_log.dart';

/// 사용자 데이터 분석기 - 실제 로그 데이터 분석
class UserDataAnalyzer {
  
  /// 로그 데이터를 분석해서 최적 패턴 찾기
  static AnalysisResult analyzeUserBehavior(List<UserBehaviorLog> logs) {
    if (logs.isEmpty) {
      return AnalysisResult.empty();
    }

    // 1. 시간별/요일별 성공률 계산
    final timeSuccessRate = _calculateTimeSuccessRate(logs);
    final daySuccessRate = _calculateDaySuccessRate(logs);
    
    // 2. 알림 반응 시간 분석
    final avgResponseTime = _calculateAverageResponseTime(logs);
    
    // 3. 최적 시간 찾기
    final bestTime = _findOptimalTime(timeSuccessRate, daySuccessRate);
    
    // 4. 개인화 메시지 생성
    final personalizedMessage = _generatePersonalizedMessage(bestTime, avgResponseTime);
    
    return AnalysisResult(
      bestTime: bestTime,
      averageResponseMinutes: avgResponseTime,
      personalizedMessage: personalizedMessage,
      hourlySuccessRate: timeSuccessRate,
      dailySuccessRate: daySuccessRate,
    );
  }

  /// 시간별 성공률 계산 (0-23시)
  static Map<int, double> _calculateTimeSuccessRate(List<UserBehaviorLog> logs) {
    final hourlyStats = <int, _TimeStats>{};
    
    for (final log in logs) {
      final hour = log.hourOfDay;
      hourlyStats[hour] ??= _TimeStats();
      
      if (log.behaviorType == BehaviorType.routineStarted) {
        hourlyStats[hour]!.attempts++;
      } else if (log.behaviorType == BehaviorType.routineCompleted) {
        hourlyStats[hour]!.successes++;
      }
    }
    
    final result = <int, double>{};
    for (int hour = 0; hour < 24; hour++) {
      final stats = hourlyStats[hour];
      if (stats != null && stats.attempts > 0) {
        result[hour] = (stats.successes / stats.attempts * 100);
      } else {
        result[hour] = 0.0;
      }
    }
    
    return result;
  }

  /// 요일별 성공률 계산 (1=월, 7=일)
  static Map<int, double> _calculateDaySuccessRate(List<UserBehaviorLog> logs) {
    final dailyStats = <int, _TimeStats>{};
    
    for (final log in logs) {
      final day = log.dayOfWeek;
      dailyStats[day] ??= _TimeStats();
      
      if (log.behaviorType == BehaviorType.routineStarted) {
        dailyStats[day]!.attempts++;
      } else if (log.behaviorType == BehaviorType.routineCompleted) {
        dailyStats[day]!.successes++;
      }
    }
    
    final result = <int, double>{};
    for (int day = 1; day <= 7; day++) {
      final stats = dailyStats[day];
      if (stats != null && stats.attempts > 0) {
        result[day] = (stats.successes / stats.attempts * 100);
      } else {
        result[day] = 0.0;
      }
    }
    
    return result;
  }

  /// 평균 알림 반응 시간 계산 (분 단위)
  static int _calculateAverageResponseTime(List<UserBehaviorLog> logs) {
    final responseLogs = logs.where((log) => 
        log.responseDelay != null && 
        log.behaviorType == BehaviorType.notificationResponded).toList();
    
    if (responseLogs.isEmpty) return 5; // 기본값 5분
    
    final totalMinutes = responseLogs
        .map((log) => log.responseDelay!.inMinutes)
        .reduce((a, b) => a + b);
    
    return (totalMinutes / responseLogs.length).round();
  }

  /// 최적 시간 찾기
  static OptimalTimeSlot _findOptimalTime(
    Map<int, double> hourlySuccessRate, 
    Map<int, double> dailySuccessRate,
  ) {
    // 가장 성공률 높은 시간대 찾기
    final bestHourEntry = hourlySuccessRate.entries
        .where((entry) => entry.value > 0)
        .reduce((a, b) => a.value > b.value ? a : b);
    
    // 가장 성공률 높은 요일 찾기  
    final bestDayEntry = dailySuccessRate.entries
        .where((entry) => entry.value > 0)
        .reduce((a, b) => a.value > b.value ? a : b);
    
    return OptimalTimeSlot(
      dayOfWeek: bestDayEntry.key,
      hour: bestHourEntry.key,
      successRate: bestHourEntry.value,
      dayName: _getDayName(bestDayEntry.key),
      timeSlot: _getTimeSlotName(bestHourEntry.key),
    );
  }

  /// 개인화된 메시지 생성
  static String _generatePersonalizedMessage(OptimalTimeSlot bestTime, int avgResponseMinutes) {
    final messages = [
      "${bestTime.dayName} ${bestTime.timeSlot}은 당신의 최적의 루틴 시간이에요! 지난주도 멋지게 해냈죠. 오늘도 가볍게 시작해볼까요? ☀️",
      "${bestTime.dayName} ${bestTime.timeSlot}에 ${bestTime.successRate.round()}% 성공률을 보여주셨어요! 이 시간이 당신에게 딱이네요 ✨",
      "${bestTime.dayName} ${bestTime.timeSlot}은 당신의 골든타임! 평소처럼 자연스럽게 시작해보세요 💪",
      "${bestTime.dayName} ${bestTime.timeSlot}에 늘 성공하셨죠! 오늘도 그 시간에 시작해볼까요? 🌟",
    ];
    
    return messages[bestTime.hour % messages.length];
  }

  static String _getDayName(int dayOfWeek) {
    const days = ['', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return days[dayOfWeek];
  }
  
  static String _getTimeSlotName(int hour) {
    if (hour < 6) return '새벽 ${hour}시';
    if (hour < 12) return '오전 ${hour}시';
    if (hour < 18) return '오후 ${hour}시'; 
    return '저녁 ${hour}시';
  }

  /// 샘플 데이터 생성 (테스트용)
  static List<UserBehaviorLog> generateSampleData() {
    final logs = <UserBehaviorLog>[];
    final userId = 'user_sample';
    final routineId = 'routine_morning';
    
    // 3주간의 가상 데이터 생성
    final now = DateTime.now();
    
    for (int day = 0; day < 21; day++) {
      final date = now.subtract(Duration(days: day));
      
      // 월요일 오전 6시에 높은 성공률 (90%)
      if (date.weekday == 1) {
        _addRoutineLog(logs, userId, routineId, date.copyWith(hour: 6), day < 19, 2); // 19/21 성공
      }
      // 화요일 오후 2시에 중간 성공률 (66%)
      if (date.weekday == 2) {
        _addRoutineLog(logs, userId, routineId, date.copyWith(hour: 14), day % 3 != 0, 4); // 2/3 성공
      }
      // 금요일 저녁 8시에 낮은 성공률 (20%)
      if (date.weekday == 5) {
        _addRoutineLog(logs, userId, routineId, date.copyWith(hour: 20), day % 5 == 0, 8); // 1/5 성공
      }
      // 수요일 오전 9시에 중간 성공률 (75%)
      if (date.weekday == 3) {
        _addRoutineLog(logs, userId, routineId, date.copyWith(hour: 9), day % 4 != 0, 3); // 3/4 성공
      }
    }
    
    return logs;
  }

  static void _addRoutineLog(
    List<UserBehaviorLog> logs, 
    String userId, 
    String routineId, 
    DateTime time, 
    bool success,
    int responseMinutes,
  ) {
    final notificationTime = time.subtract(Duration(minutes: responseMinutes));
    
    // 알림 발송 로그
    logs.add(UserBehaviorLog(
      id: 'log_${time.millisecondsSinceEpoch}_notif',
      userId: userId,
      routineId: routineId,
      routineItemId: 'item_1',
      behaviorType: BehaviorType.notificationResponded,
      timestamp: time,
      dayOfWeek: time.weekday,
      hourOfDay: time.hour,
      notificationSentAt: notificationTime,
      responseDelay: Duration(minutes: responseMinutes),
    ));
    
    // 루틴 시작 로그
    logs.add(UserBehaviorLog(
      id: 'log_${time.millisecondsSinceEpoch}_start',
      userId: userId,
      routineId: routineId,
      routineItemId: 'item_1',
      behaviorType: BehaviorType.routineStarted,
      timestamp: time,
      dayOfWeek: time.weekday,
      hourOfDay: time.hour,
    ));
    
    // 성공 시 완료 로그 추가
    if (success) {
      logs.add(UserBehaviorLog(
        id: 'log_${time.millisecondsSinceEpoch}_complete',
        userId: userId,
        routineId: routineId,
        routineItemId: 'item_1',
        behaviorType: BehaviorType.routineCompleted,
        timestamp: time.add(Duration(minutes: 30)),
        dayOfWeek: time.weekday,
        hourOfDay: time.hour,
      ));
    }
  }
}

/// 분석 결과 모델
class AnalysisResult {
  final OptimalTimeSlot bestTime;
  final int averageResponseMinutes;
  final String personalizedMessage;
  final Map<int, double> hourlySuccessRate;
  final Map<int, double> dailySuccessRate;
  
  AnalysisResult({
    required this.bestTime,
    required this.averageResponseMinutes,
    required this.personalizedMessage,
    required this.hourlySuccessRate,
    required this.dailySuccessRate,
  });
  
  factory AnalysisResult.empty() {
    return AnalysisResult(
      bestTime: OptimalTimeSlot(
        dayOfWeek: 1,
        hour: 8,
        successRate: 0.0,
        dayName: '월요일',
        timeSlot: '오전 8시',
      ),
      averageResponseMinutes: 5,
      personalizedMessage: '루틴을 시작해보세요! ✨',
      hourlySuccessRate: {},
      dailySuccessRate: {},
    );
  }
}

/// 최적 시간대 정보
class OptimalTimeSlot {
  final int dayOfWeek;
  final int hour;
  final double successRate;
  final String dayName;
  final String timeSlot;
  
  OptimalTimeSlot({
    required this.dayOfWeek,
    required this.hour,
    required this.successRate,
    required this.dayName,
    required this.timeSlot,
  });
}

/// 내부 통계 계산용 헬퍼 클래스
class _TimeStats {
  int attempts = 0;
  int successes = 0;
}