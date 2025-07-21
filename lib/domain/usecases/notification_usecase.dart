import 'package:injectable/injectable.dart';
import '../entities/daily_routine.dart';
import '../entities/notification_settings.dart';
import '../repositories/notification_repository.dart';
import '../services/notification_service.dart';

@injectable
class NotificationUseCase {
  final NotificationRepository _notificationRepository;
  final NotificationService _notificationService;

  NotificationUseCase(
    this._notificationRepository,
    this._notificationService,
  );

  /// 알림 서비스 초기화
  Future<void> initializeNotifications() async {
    await _notificationService.initialize();
  }

  /// 알림 권한 요청
  Future<bool> requestNotificationPermissions() async {
    return await _notificationService.requestPermissions();
  }

  /// 알림 설정 불러오기
  Future<NotificationSettings> getNotificationSettings() async {
    return await _notificationRepository.getNotificationSettings();
  }

  /// 알림 설정 저장
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    await _notificationRepository.saveNotificationSettings(settings);
    
    // 설정 변경에 따른 알림 재스케줄링
    if (!settings.isEnabled) {
      await _notificationService.cancelAllNotifications();
    }
  }

  /// 루틴에 대한 알림 예약
  Future<void> scheduleRoutineNotifications(DailyRoutine routine) async {
    final settings = await _notificationRepository.getNotificationSettings();
    
    if (!settings.isEnabled) return;

    // 기존 루틴 알림 취소
    await _notificationService.cancelRoutineNotifications(routine.id);

    final now = DateTime.now();
    
    // 루틴 시작 알림
    if (settings.routineReminders && routine.items.isNotEmpty) {
      final firstItem = routine.items.first;
      final startDateTime = _timeOfDayToDateTime(firstItem.startTime);
      final reminderTime = _calculateReminderTime(
        startDateTime,
        settings.reminderMinutesBefore,
      );
      
      if (reminderTime.isAfter(now)) {
        await _notificationService.scheduleRoutineReminder(
          routine: routine,
          scheduledTime: reminderTime,
        );
      }
    }

    // 개별 아이템 알림
    if (settings.itemReminders) {
      for (final item in routine.items) {
        final itemStartDateTime = _timeOfDayToDateTime(item.startTime);
        final itemReminderTime = _calculateReminderTime(
          itemStartDateTime,
          5, // 아이템은 5분 전 알림
        );
        
        if (itemReminderTime.isAfter(now)) {
          await _notificationService.scheduleItemReminder(
            item: item,
            scheduledTime: itemReminderTime,
            routineTitle: routine.title,
          );
        }
      }
    }
  }

  /// 일일 완료 리마인더 예약
  Future<void> scheduleDailyCompletionReminder() async {
    final settings = await _notificationRepository.getNotificationSettings();
    
    if (!settings.isEnabled || !settings.dailyCompletionReminder) return;

    final now = DateTime.now();
    var reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      settings.dailyReminderHour,
      settings.dailyReminderMinute,
    );

    // 오늘 시간이 지났으면 내일로 설정
    if (reminderTime.isBefore(now)) {
      reminderTime = reminderTime.add(const Duration(days: 1));
    }

    await _notificationService.scheduleDailyCompletionReminder(
      scheduledTime: reminderTime,
    );
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  /// 특정 루틴 알림 취소
  Future<void> cancelRoutineNotifications(String routineId) async {
    await _notificationService.cancelRoutineNotifications(routineId);
  }

  /// 알림 활성화 상태 확인
  Future<bool> areNotificationsEnabled() async {
    return await _notificationService.areNotificationsEnabled();
  }

  /// 예약된 알림 개수 조회
  Future<int> getPendingNotificationCount() async {
    final pendingNotifications = await _notificationService.getPendingNotifications();
    return pendingNotifications.length;
  }

  /// 알림 타입별 토글
  Future<void> toggleNotificationType(NotificationType type, bool enabled) async {
    await _notificationRepository.toggleNotificationType(type, enabled);
  }

  /// 리마인더 시간 업데이트
  Future<void> updateReminderTime(int minutesBefore) async {
    await _notificationRepository.updateReminderTime(minutesBefore);
  }

  /// 일일 리마인더 시간 업데이트
  Future<void> updateDailyReminderTime(int hour, int minute) async {
    await _notificationRepository.updateDailyReminderTime(hour, minute);
  }

  /// 리마인더 시간 계산
  DateTime _calculateReminderTime(DateTime startTime, int minutesBefore) {
    final now = DateTime.now();
    var reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    ).subtract(Duration(minutes: minutesBefore));

    // 과거 시간이면 내일로 설정
    if (reminderTime.isBefore(now)) {
      reminderTime = reminderTime.add(const Duration(days: 1));
    }

    return reminderTime;
  }

  /// TimeOfDay를 오늘 날짜의 DateTime으로 변환
  DateTime _timeOfDayToDateTime(dynamic timeOfDay) {
    final now = DateTime.now();
    
    // TimeOfDay 타입인 경우
    if (timeOfDay.runtimeType.toString().contains('TimeOfDay')) {
      return DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    }
    
    // 이미 DateTime인 경우
    if (timeOfDay is DateTime) {
      return DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    }
    
    // 기본값 반환 (현재 시간)
    return now;
  }
}