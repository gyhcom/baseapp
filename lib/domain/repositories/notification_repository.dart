import '../entities/notification_settings.dart';

/// 알림 설정 리포지토리 인터페이스
abstract class NotificationRepository {
  /// 알림 설정 불러오기
  Future<NotificationSettings> getNotificationSettings();

  /// 알림 설정 저장
  Future<void> saveNotificationSettings(NotificationSettings settings);

  /// 특정 알림 타입 활성화/비활성화
  Future<void> toggleNotificationType(NotificationType type, bool enabled);

  /// 알림 시간 설정 업데이트
  Future<void> updateReminderTime(int minutesBefore);

  /// 일일 리마인더 시간 업데이트
  Future<void> updateDailyReminderTime(int hour, int minute);

  /// 알림 설정 초기화
  Future<void> resetToDefault();
}