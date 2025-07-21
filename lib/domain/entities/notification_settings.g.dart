// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingsAdapter extends TypeAdapter<NotificationSettings> {
  @override
  final int typeId = 7;

  @override
  NotificationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSettings(
      isEnabled: fields[0] as bool,
      routineReminders: fields[1] as bool,
      itemReminders: fields[2] as bool,
      dailyCompletionReminder: fields[3] as bool,
      reminderMinutesBefore: fields[4] as int,
      dailyReminderHour: fields[5] as int,
      dailyReminderMinute: fields[6] as int,
      soundEnabled: fields[7] as bool,
      vibrationEnabled: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSettings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.isEnabled)
      ..writeByte(1)
      ..write(obj.routineReminders)
      ..writeByte(2)
      ..write(obj.itemReminders)
      ..writeByte(3)
      ..write(obj.dailyCompletionReminder)
      ..writeByte(4)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(5)
      ..write(obj.dailyReminderHour)
      ..writeByte(6)
      ..write(obj.dailyReminderMinute)
      ..writeByte(7)
      ..write(obj.soundEnabled)
      ..writeByte(8)
      ..write(obj.vibrationEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      isEnabled: json['isEnabled'] as bool? ?? true,
      routineReminders: json['routineReminders'] as bool? ?? true,
      itemReminders: json['itemReminders'] as bool? ?? true,
      dailyCompletionReminder: json['dailyCompletionReminder'] as bool? ?? true,
      reminderMinutesBefore:
          (json['reminderMinutesBefore'] as num?)?.toInt() ?? 15,
      dailyReminderHour: (json['dailyReminderHour'] as num?)?.toInt() ?? 21,
      dailyReminderMinute: (json['dailyReminderMinute'] as num?)?.toInt() ?? 0,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'routineReminders': instance.routineReminders,
      'itemReminders': instance.itemReminders,
      'dailyCompletionReminder': instance.dailyCompletionReminder,
      'reminderMinutesBefore': instance.reminderMinutesBefore,
      'dailyReminderHour': instance.dailyReminderHour,
      'dailyReminderMinute': instance.dailyReminderMinute,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
    };
