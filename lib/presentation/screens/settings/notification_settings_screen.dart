import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../../domain/entities/notification_settings.dart';
import '../../../domain/usecases/notification_usecase.dart';
import '../../../di/service_locator.dart';

/// 알림 설정 화면
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  final NotificationUseCase _notificationUseCase = getIt<NotificationUseCase>();
  
  NotificationSettings? _settings;
  bool _isLoading = true;
  int _pendingNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _notificationUseCase.getNotificationSettings();
      final count = await _notificationUseCase.getPendingNotificationCount();
      
      setState(() {
        _settings = settings;
        _pendingNotificationCount = count;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateSettings(NotificationSettings newSettings) async {
    try {
      await _notificationUseCase.saveNotificationSettings(newSettings);
      setState(() {
        _settings = newSettings;
      });
      
      // 알림 개수 업데이트
      final count = await _notificationUseCase.getPendingNotificationCount();
      setState(() {
        _pendingNotificationCount = count;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('알림 설정이 저장되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('설정 저장에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('알림 설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _settings == null
              ? _buildErrorState()
              : _buildSettingsContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text('알림 설정을 불러올 수 없습니다'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSettings,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return ListView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      children: [
        // 알림 상태 카드
        _buildStatusCard(),
        
        const SizedBox(height: AppTheme.spacingL),
        
        // 마스터 스위치
        _buildMasterSwitch(),
        
        const SizedBox(height: AppTheme.spacingL),
        
        // 알림 타입별 설정
        if (_settings!.isEnabled) ...[
          _buildSectionHeader('알림 타입'),
          _buildNotificationTypeSettings(),
          
          const SizedBox(height: AppTheme.spacingL),
          
          _buildSectionHeader('시간 설정'),
          _buildTimeSettings(),
          
          const SizedBox(height: AppTheme.spacingL),
          
          _buildSectionHeader('기타 설정'),
          _buildOtherSettings(),
        ],
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _settings!.isEnabled ? Icons.notifications_active : Icons.notifications_off,
                color: _settings!.isEnabled ? Colors.green : Colors.grey,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '알림 상태',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          Text(
            _settings!.isEnabled ? '알림이 활성화되어 있습니다' : '알림이 비활성화되어 있습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          
          if (_settings!.isEnabled) ...[
            const SizedBox(height: AppTheme.spacingS),
            Text(
              '예약된 알림: $_pendingNotificationCount개',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMasterSwitch() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingM),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '알림 허용',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '루틴 리마인더 및 알림을 받습니다',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          Switch(
            value: _settings!.isEnabled,
            onChanged: (value) {
              _updateSettings(_settings!.copyWith(isEnabled: value));
            },
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildNotificationTypeSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: '루틴 시작 알림',
            subtitle: '루틴 시작 ${_settings!.reminderMinutesBefore}분 전에 알림',
            value: _settings!.routineReminders,
            onChanged: (value) {
              _updateSettings(_settings!.copyWith(routineReminders: value));
            },
            icon: Icons.play_circle_outline,
          ),
          
          const Divider(height: 1),
          
          _buildSwitchTile(
            title: '활동 리마인더',
            subtitle: '개별 활동 시작 5분 전에 알림',
            value: _settings!.itemReminders,
            onChanged: (value) {
              _updateSettings(_settings!.copyWith(itemReminders: value));
            },
            icon: Icons.schedule,
          ),
          
          const Divider(height: 1),
          
          _buildSwitchTile(
            title: '일일 완료 리마인더',
            subtitle: '매일 ${_settings!.dailyReminderHour}:${_settings!.dailyReminderMinute.toString().padLeft(2, '0')}에 알림',
            value: _settings!.dailyCompletionReminder,
            onChanged: (value) {
              _updateSettings(_settings!.copyWith(dailyCompletionReminder: value));
            },
            icon: Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          _buildTimeTile(
            title: '루틴 시작 알림 시간',
            subtitle: '루틴 시작 몇 분 전에 알림할지 설정',
            value: '${_settings!.reminderMinutesBefore}분 전',
            onTap: () => _showReminderTimePicker(),
            icon: Icons.access_time,
          ),
          
          const Divider(height: 1),
          
          _buildTimeTile(
            title: '일일 리마인더 시간',
            subtitle: '매일 루틴 완료 확인 알림 시간',
            value: '${_settings!.dailyReminderHour}:${_settings!.dailyReminderMinute.toString().padLeft(2, '0')}',
            onTap: () => _showDailyReminderTimePicker(),
            icon: Icons.schedule,
          ),
        ],
      ),
    );
  }

  Widget _buildOtherSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: '알림 소리',
            subtitle: '알림 시 소리를 재생합니다',
            value: _settings!.soundEnabled,
            onChanged: (value) {
              _updateSettings(_settings!.copyWith(soundEnabled: value));
            },
            icon: Icons.volume_up,
          ),
          
          const Divider(height: 1),
          
          _buildSwitchTile(
            title: '진동',
            subtitle: '알림 시 진동을 사용합니다',
            value: _settings!.vibrationEnabled,
            onChanged: (value) {
              _updateSettings(_settings!.copyWith(vibrationEnabled: value));
            },
            icon: Icons.vibration,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingM),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTile({
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.largeRadius,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingM),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingS),
            
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderTimePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 시작 알림 시간'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [5, 10, 15, 30, 60].map((minutes) => 
            RadioListTile<int>(
              title: Text('${minutes}분 전'),
              value: minutes,
              groupValue: _settings!.reminderMinutesBefore,
              onChanged: (value) {
                Navigator.pop(context);
                if (value != null) {
                  _updateSettings(_settings!.copyWith(reminderMinutesBefore: value));
                }
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _showDailyReminderTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _settings!.dailyReminderHour,
        minute: _settings!.dailyReminderMinute,
      ),
    );

    if (time != null) {
      _updateSettings(_settings!.copyWith(
        dailyReminderHour: time.hour,
        dailyReminderMinute: time.minute,
      ));
    }
  }
}