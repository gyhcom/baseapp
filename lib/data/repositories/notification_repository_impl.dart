import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  static const String _boxName = 'notification_settings';
  static const String _settingsKey = 'settings';

  Box<NotificationSettings>? _box;

  Future<Box<NotificationSettings>> get _settingsBox async {
    if (_box?.isOpen == true) {
      return _box!;
    }
    _box = await Hive.openBox<NotificationSettings>(_boxName);
    return _box!;
  }

  @override
  Future<NotificationSettings> getNotificationSettings() async {
    try {
      final box = await _settingsBox;
      return box.get(_settingsKey) ?? const NotificationSettings();
    } catch (e) {
      print('알림 설정 로드 실패: $e');
      return const NotificationSettings();
    }
  }

  @override
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    try {
      final box = await _settingsBox;
      await box.put(_settingsKey, settings);
    } catch (e) {
      print('알림 설정 저장 실패: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleNotificationType(NotificationType type, bool enabled) async {
    final currentSettings = await getNotificationSettings();
    
    final updatedSettings = switch (type) {
      NotificationType.routineStart => currentSettings.copyWith(routineReminders: enabled),
      NotificationType.itemReminder => currentSettings.copyWith(itemReminders: enabled),
      NotificationType.dailyCompletion => currentSettings.copyWith(dailyCompletionReminder: enabled),
    };

    await saveNotificationSettings(updatedSettings);
  }

  @override
  Future<void> updateReminderTime(int minutesBefore) async {
    final currentSettings = await getNotificationSettings();
    final updatedSettings = currentSettings.copyWith(reminderMinutesBefore: minutesBefore);
    await saveNotificationSettings(updatedSettings);
  }

  @override
  Future<void> updateDailyReminderTime(int hour, int minute) async {
    final currentSettings = await getNotificationSettings();
    final updatedSettings = currentSettings.copyWith(
      dailyReminderHour: hour,
      dailyReminderMinute: minute,
    );
    await saveNotificationSettings(updatedSettings);
  }

  @override
  Future<void> resetToDefault() async {
    await saveNotificationSettings(const NotificationSettings());
  }
}