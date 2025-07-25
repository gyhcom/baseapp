import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_behavior_log.freezed.dart';
part 'user_behavior_log.g.dart';

/// 사용자 행동 로그 - 패턴 분석용 데이터
@freezed
class UserBehaviorLog with _$UserBehaviorLog {
  const factory UserBehaviorLog({
    required String id,
    required String userId,
    required String routineId,
    required String routineItemId,
    required BehaviorType behaviorType,
    required DateTime timestamp,
    
    // 컨텍스트 정보
    required int dayOfWeek,        // 1=월요일, 7=일요일
    required int hourOfDay,        // 0-23
    String? weather,               // 날씨 정보 (선택)
    String? location,              // 위치 정보 (선택)
    
    // 알림 관련
    DateTime? notificationSentAt,  // 알림 발송 시간
    Duration? responseDelay,       // 알림 후 응답까지 시간
    
    // 추가 메타데이터
    Map<String, dynamic>? metadata,
    
    @Default(false) bool isSynced,
  }) = _UserBehaviorLog;

  factory UserBehaviorLog.fromJson(Map<String, dynamic> json) =>
      _$UserBehaviorLogFromJson(json);
}

/// 행동 유형
enum BehaviorType {
  @JsonValue('routine_started')
  routineStarted,           // 루틴 시작
  
  @JsonValue('routine_completed')
  routineCompleted,         // 루틴 완료
  
  @JsonValue('routine_skipped')
  routineSkipped,           // 루틴 건너뛰기
  
  @JsonValue('routine_delayed')
  routineDelayed,           // 루틴 지연
  
  @JsonValue('notification_dismissed')
  notificationDismissed,    // 알림 무시/제거
  
  @JsonValue('notification_responded')
  notificationResponded,    // 알림에 응답
  
  @JsonValue('app_opened')
  appOpened,                // 앱 열기
  
  @JsonValue('routine_viewed')
  routineViewed,            // 루틴 상세 보기
}

/// 행동 패턴 분석 결과
@freezed 
class BehaviorPattern with _$BehaviorPattern {
  const factory BehaviorPattern({
    required String userId,
    required String routineId,
    
    // 시간 패턴
    required Map<int, double> hourlySuccessRate,    // 시간별 성공률 0-23
    required Map<int, double> weeklySuccessRate,    // 요일별 성공률 1-7
    
    // 알림 반응 패턴  
    required Duration averageResponseTime,          // 평균 응답 시간
    required double notificationEffectiveness,      // 알림 효과성 (0.0-1.0)
    
    // 연속성 패턴
    required int currentStreak,                     // 현재 연속 성공
    required int longestStreak,                     // 최장 연속 성공
    required double overallSuccessRate,             // 전체 성공률
    
    // 예측된 최적 시간
    required List<OptimalTime> suggestedTimes,
    
    required DateTime lastUpdated,
    required int totalDataPoints,                   // 분석 데이터 포인트 수
  }) = _BehaviorPattern;

  factory BehaviorPattern.fromJson(Map<String, dynamic> json) =>
      _$BehaviorPatternFromJson(json);
}

/// 최적 시간 추천
@freezed
class OptimalTime with _$OptimalTime {
  const factory OptimalTime({
    required int dayOfWeek,
    required int hour,
    required double successProbability,  // 성공 확률 0.0-1.0
    required String reason,              // 추천 이유
  }) = _OptimalTime;

  factory OptimalTime.fromJson(Map<String, dynamic> json) =>
      _$OptimalTimeFromJson(json);
}