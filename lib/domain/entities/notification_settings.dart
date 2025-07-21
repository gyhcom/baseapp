import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// 알림 설정 엔티티
@freezed
@HiveType(typeId: 7)
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @HiveField(0) @Default(true) bool isEnabled,
    @HiveField(1) @Default(true) bool routineReminders,
    @HiveField(2) @Default(true) bool itemReminders,
    @HiveField(3) @Default(true) bool dailyCompletionReminder,
    @HiveField(4) @Default(15) int reminderMinutesBefore,
    @HiveField(5) @Default(21) int dailyReminderHour, // 21시 (오후 9시)
    @HiveField(6) @Default(0) int dailyReminderMinute,
    @HiveField(7) @Default(true) bool soundEnabled,
    @HiveField(8) @Default(true) bool vibrationEnabled,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// 알림 타입 열거형
enum NotificationType {
  routineStart('루틴 시작'),
  itemReminder('활동 리마인더'),
  dailyCompletion('일일 완료');

  const NotificationType(this.displayName);
  final String displayName;
}

/// 알림 우선순위
enum NotificationPriority {
  low('낮음'),
  normal('보통'),
  high('높음');

  const NotificationPriority(this.displayName);
  final String displayName;
}