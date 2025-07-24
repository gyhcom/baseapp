import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/user_behavior_log.dart';
import '../../../domain/usecases/notification_usecase.dart';
import '../../../domain/services/behavior_analytics_service.dart';
import '../../../di/service_locator.dart';

/// 루틴 알림 도우미 클래스
class RoutineNotificationHelper {
  static final NotificationUseCase _notificationUseCase = getIt<NotificationUseCase>();
  static final BehaviorAnalyticsService _behaviorAnalytics = getIt<BehaviorAnalyticsService>();

  /// 루틴 저장 시 알림 예약
  static Future<void> scheduleNotificationsForRoutine(DailyRoutine routine) async {
    try {
      // 알림이 활성화되어 있는지 확인
      final settings = await _notificationUseCase.getNotificationSettings();
      if (!settings.isEnabled) {
        return;
      }

      // 루틴에 대한 알림 예약
      await _notificationUseCase.scheduleRoutineNotifications(routine);
      
      // 알림 예약 로그 (향후 분석용) - 임시 비활성화
      // await _logNotificationScheduled(routine);
      
      print('✅ 알림이 예약되었습니다: ${routine.title}');
    } catch (e) {
      print('❌ 알림 예약 실패: $e');
      // 에러가 발생해도 루틴 저장에는 영향을 주지 않음
    }
  }

  /// 알림 예약 로그 기록
  static Future<void> _logNotificationScheduled(DailyRoutine routine) async {
    try {
      await _behaviorAnalytics.logBehavior(
        userId: 'current_user', // 실제로는 현재 사용자 ID
        routineId: routine.id,
        routineItemId: 'notification_scheduled',
        behaviorType: BehaviorType.routineViewed, // 임시로 사용
        metadata: {
          'notification_time': DateTime.now().add(const Duration(hours: 8)).toIso8601String(),
          'routine_title': routine.title,
        },
      );
    } catch (e) {
      print('알림 예약 로그 실패: $e');
    }
  }

  /// 루틴 삭제 시 관련 알림 취소
  static Future<void> cancelNotificationsForRoutine(String routineId) async {
    try {
      await _notificationUseCase.cancelRoutineNotifications(routineId);
      print('알림이 취소되었습니다: $routineId');
    } catch (e) {
      print('알림 취소 실패: $e');
    }
  }

  /// 알림 권한 요청
  static Future<bool> requestNotificationPermissions() async {
    try {
      return await _notificationUseCase.requestNotificationPermissions();
    } catch (e) {
      print('알림 권한 요청 실패: $e');
      return false;
    }
  }

  /// 앱 시작 시 알림 초기화
  static Future<void> initializeNotifications() async {
    try {
      await _notificationUseCase.initializeNotifications();
      
      // 일일 완료 리마인더 예약
      await _notificationUseCase.scheduleDailyCompletionReminder();
      
      print('알림 서비스가 초기화되었습니다');
    } catch (e) {
      print('알림 초기화 실패: $e');
    }
  }
}