import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/behavior_analytics_service.dart';
import '../../domain/entities/user_behavior_log.dart';
import '../../di/service_locator.dart';

/// 행동 분석 서비스 Provider
final behaviorAnalyticsServiceProvider = Provider<BehaviorAnalyticsService>((ref) {
  return getIt<BehaviorAnalyticsService>();
});

/// 행동 로그 기록 Provider
final behaviorLoggerProvider = Provider<BehaviorLogger>((ref) {
  final analyticsService = ref.watch(behaviorAnalyticsServiceProvider);
  return BehaviorLogger(analyticsService);
});

/// 사용자 행동 로그 기록 헬퍼 클래스
class BehaviorLogger {
  final BehaviorAnalyticsService _analyticsService;
  
  BehaviorLogger(this._analyticsService);

  /// 루틴 시작 로그
  Future<void> logRoutineStarted({
    required String userId,
    required String routineId,
    required String routineItemId,
    DateTime? notificationSentAt,
  }) async {
    print('📊 루틴 시작 로그: $routineId');
    
    await _analyticsService.logBehavior(
      userId: userId,
      routineId: routineId,
      routineItemId: routineItemId,
      behaviorType: BehaviorType.routineStarted,
      notificationSentAt: notificationSentAt,
      metadata: {
        'source': 'user_action',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// 루틴 완료 로그
  Future<void> logRoutineCompleted({
    required String userId,
    required String routineId,
    required String routineItemId,
    Duration? duration,
  }) async {
    print('📊 루틴 완료 로그: $routineId');
    
    await _analyticsService.logBehavior(
      userId: userId,
      routineId: routineId,
      routineItemId: routineItemId,
      behaviorType: BehaviorType.routineCompleted,
      metadata: {
        'duration_minutes': duration?.inMinutes,
        'completed_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// 루틴 건너뛰기 로그
  Future<void> logRoutineSkipped({
    required String userId,
    required String routineId,
    required String routineItemId,
    String? reason,
  }) async {
    print('📊 루틴 건너뛰기 로그: $routineId');
    
    await _analyticsService.logBehavior(
      userId: userId,
      routineId: routineId,
      routineItemId: routineItemId,
      behaviorType: BehaviorType.routineSkipped,
      metadata: {
        'reason': reason ?? 'user_skip',
        'skipped_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// 알림 응답 로그
  Future<void> logNotificationResponded({
    required String userId,
    required String routineId,
    required String routineItemId,
    required DateTime notificationSentAt,
  }) async {
    print('📊 알림 응답 로그: $routineId');
    
    await _analyticsService.logBehavior(
      userId: userId,
      routineId: routineId,
      routineItemId: routineItemId,
      behaviorType: BehaviorType.notificationResponded,
      notificationSentAt: notificationSentAt,
      metadata: {
        'response_method': 'notification_tap',
        'responded_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// 앱 열기 로그
  Future<void> logAppOpened({
    required String userId,
    String? source,
  }) async {
    print('📊 앱 열기 로그');
    
    await _analyticsService.logBehavior(
      userId: userId,
      routineId: 'app_session', // 특별한 ID
      routineItemId: 'app_open',
      behaviorType: BehaviorType.appOpened,
      metadata: {
        'source': source ?? 'direct',
        'opened_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// 간편 로그 기록 (가장 자주 사용)
  Future<void> quickLog({
    required String userId,
    required String routineId,
    required BehaviorType type,
    DateTime? notificationTime,
  }) async {
    await _analyticsService.logBehavior(
      userId: userId,
      routineId: routineId,
      routineItemId: 'main_routine',
      behaviorType: type,
      notificationSentAt: notificationTime,
    );
  }
}

/// 사용자 패턴 분석 결과 Provider
final userPatternAnalysisProvider = FutureProvider.family<BehaviorPattern?, String>((ref, userId) async {
  final analyticsService = ref.watch(behaviorAnalyticsServiceProvider);
  
  // 임시로 더미 루틴 ID 사용 (실제로는 현재 활성 루틴 ID 사용)
  return await analyticsService.analyzeBehaviorPattern(
    userId: userId,
    routineId: 'active_routine',
    analysisPeriodDays: 14, // 2주간 분석
  );
});

/// 최적 시간 추천 Provider  
final optimalTimeRecommendationProvider = FutureProvider.family<List<OptimalTime>, String>((ref, userId) async {
  final pattern = await ref.watch(userPatternAnalysisProvider(userId).future);
  
  if (pattern == null) return [];
  
  return pattern.suggestedTimes;
});