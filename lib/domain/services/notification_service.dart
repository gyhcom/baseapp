import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../entities/daily_routine.dart';
import '../entities/routine_item.dart';

/// 알림 서비스 인터페이스
abstract class NotificationService {
  /// 알림 서비스 초기화
  Future<void> initialize();

  /// 권한 요청
  Future<bool> requestPermissions();

  /// 루틴 시작 알림 예약
  Future<void> scheduleRoutineReminder({
    required DailyRoutine routine,
    required DateTime scheduledTime,
  });

  /// 루틴 아이템 알림 예약
  Future<void> scheduleItemReminder({
    required RoutineItem item,
    required DateTime scheduledTime,
    required String routineTitle,
  });

  /// 일일 루틴 완료 리마인더 예약
  Future<void> scheduleDailyCompletionReminder({
    required DateTime scheduledTime,
  });

  /// 특정 알림 취소
  Future<void> cancelNotification(int notificationId);

  /// 루틴 관련 모든 알림 취소
  Future<void> cancelRoutineNotifications(String routineId);

  /// 모든 알림 취소
  Future<void> cancelAllNotifications();

  /// 예약된 알림 목록 조회
  Future<List<PendingNotificationRequest>> getPendingNotifications();

  /// 알림 설정 상태 확인
  Future<bool> areNotificationsEnabled();
}

/// 로컬 알림 서비스 구현
class LocalNotificationService implements NotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // 알림 탭 시 처리 로직
    // 향후 라우팅 처리 구현 예정
    print('알림 탭됨: ${response.payload}');
  }

  @override
  Future<bool> requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return await areNotificationsEnabled();
  }

  @override
  Future<void> scheduleRoutineReminder({
    required DailyRoutine routine,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) await initialize();

    final notificationId = _generateRoutineNotificationId(routine.id);
    
    await _notifications.zonedSchedule(
      notificationId,
      '🌟 루틴 시작 시간이에요!',
      '${routine.title} - ${routine.concept.displayName}',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'routine_reminders',
          '루틴 리마인더',
          channelDescription: '루틴 시작 시간을 알려드립니다',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'routine_reminder',
        ),
      ),
      payload: 'routine:${routine.id}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> scheduleItemReminder({
    required RoutineItem item,
    required DateTime scheduledTime,
    required String routineTitle,
  }) async {
    if (!_isInitialized) await initialize();

    final notificationId = _generateItemNotificationId(item.id);
    
    await _notifications.zonedSchedule(
      notificationId,
      '⏰ ${item.title}',
      '$routineTitle - ${item.timeDisplay}에 시작해요',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'item_reminders',
          '활동 리마인더',
          channelDescription: '개별 활동 시간을 알려드립니다',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'item_reminder',
        ),
      ),
      payload: 'item:${item.id}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> scheduleDailyCompletionReminder({
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) await initialize();

    await _notifications.zonedSchedule(
      999999, // 고정 ID for daily reminder
      '📝 오늘의 루틴은 어떠셨나요?',
      '루틴 완료 상황을 확인해보세요!',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders',
          '일일 리마인더',
          channelDescription: '하루 루틴 완료 상황을 확인하세요',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: 'daily_reminder',
        ),
      ),
      payload: 'daily_completion',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelNotification(int notificationId) async {
    await _notifications.cancel(notificationId);
  }

  @override
  Future<void> cancelRoutineNotifications(String routineId) async {
    final pendingNotifications = await getPendingNotifications();
    
    for (final notification in pendingNotifications) {
      if (notification.payload?.contains('routine:$routineId') == true ||
          notification.payload?.contains(routineId) == true) {
        await cancelNotification(notification.id);
      }
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final result = await androidPlugin.areNotificationsEnabled();
      return result ?? false;
    }

    // iOS에서는 설정을 직접 확인하기 어려우므로 true 반환
    return true;
  }

  /// 루틴 ID로부터 알림 ID 생성
  int _generateRoutineNotificationId(String routineId) {
    return routineId.hashCode.abs() % 100000; // 0-99999 범위
  }

  /// 아이템 ID로부터 알림 ID 생성
  int _generateItemNotificationId(String itemId) {
    return (itemId.hashCode.abs() % 100000) + 100000; // 100000-199999 범위
  }
}