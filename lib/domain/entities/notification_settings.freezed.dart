// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
  @HiveField(0)
  bool get isEnabled => throw _privateConstructorUsedError;
  @HiveField(1)
  bool get routineReminders => throw _privateConstructorUsedError;
  @HiveField(2)
  bool get itemReminders => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get dailyCompletionReminder => throw _privateConstructorUsedError;
  @HiveField(4)
  int get reminderMinutesBefore => throw _privateConstructorUsedError;
  @HiveField(5)
  int get dailyReminderHour =>
      throw _privateConstructorUsedError; // 21시 (오후 9시)
  @HiveField(6)
  int get dailyReminderMinute => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get soundEnabled => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get vibrationEnabled => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(NotificationSettings value,
          $Res Function(NotificationSettings) then) =
      _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call(
      {@HiveField(0) bool isEnabled,
      @HiveField(1) bool routineReminders,
      @HiveField(2) bool itemReminders,
      @HiveField(3) bool dailyCompletionReminder,
      @HiveField(4) int reminderMinutesBefore,
      @HiveField(5) int dailyReminderHour,
      @HiveField(6) int dailyReminderMinute,
      @HiveField(7) bool soundEnabled,
      @HiveField(8) bool vibrationEnabled});
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res,
        $Val extends NotificationSettings>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? routineReminders = null,
    Object? itemReminders = null,
    Object? dailyCompletionReminder = null,
    Object? reminderMinutesBefore = null,
    Object? dailyReminderHour = null,
    Object? dailyReminderMinute = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
  }) {
    return _then(_value.copyWith(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      routineReminders: null == routineReminders
          ? _value.routineReminders
          : routineReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      itemReminders: null == itemReminders
          ? _value.itemReminders
          : itemReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyCompletionReminder: null == dailyCompletionReminder
          ? _value.dailyCompletionReminder
          : dailyCompletionReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderMinutesBefore: null == reminderMinutesBefore
          ? _value.reminderMinutesBefore
          : reminderMinutesBefore // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderHour: null == dailyReminderHour
          ? _value.dailyReminderHour
          : dailyReminderHour // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderMinute: null == dailyReminderMinute
          ? _value.dailyReminderMinute
          : dailyReminderMinute // ignore: cast_nullable_to_non_nullable
              as int,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(_$NotificationSettingsImpl value,
          $Res Function(_$NotificationSettingsImpl) then) =
      __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) bool isEnabled,
      @HiveField(1) bool routineReminders,
      @HiveField(2) bool itemReminders,
      @HiveField(3) bool dailyCompletionReminder,
      @HiveField(4) int reminderMinutesBefore,
      @HiveField(5) int dailyReminderHour,
      @HiveField(6) int dailyReminderMinute,
      @HiveField(7) bool soundEnabled,
      @HiveField(8) bool vibrationEnabled});
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(_$NotificationSettingsImpl _value,
      $Res Function(_$NotificationSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? routineReminders = null,
    Object? itemReminders = null,
    Object? dailyCompletionReminder = null,
    Object? reminderMinutesBefore = null,
    Object? dailyReminderHour = null,
    Object? dailyReminderMinute = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
  }) {
    return _then(_$NotificationSettingsImpl(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      routineReminders: null == routineReminders
          ? _value.routineReminders
          : routineReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      itemReminders: null == itemReminders
          ? _value.itemReminders
          : itemReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyCompletionReminder: null == dailyCompletionReminder
          ? _value.dailyCompletionReminder
          : dailyCompletionReminder // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderMinutesBefore: null == reminderMinutesBefore
          ? _value.reminderMinutesBefore
          : reminderMinutesBefore // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderHour: null == dailyReminderHour
          ? _value.dailyReminderHour
          : dailyReminderHour // ignore: cast_nullable_to_non_nullable
              as int,
      dailyReminderMinute: null == dailyReminderMinute
          ? _value.dailyReminderMinute
          : dailyReminderMinute // ignore: cast_nullable_to_non_nullable
              as int,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl(
      {@HiveField(0) this.isEnabled = true,
      @HiveField(1) this.routineReminders = true,
      @HiveField(2) this.itemReminders = true,
      @HiveField(3) this.dailyCompletionReminder = true,
      @HiveField(4) this.reminderMinutesBefore = 15,
      @HiveField(5) this.dailyReminderHour = 21,
      @HiveField(6) this.dailyReminderMinute = 0,
      @HiveField(7) this.soundEnabled = true,
      @HiveField(8) this.vibrationEnabled = true});

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final bool isEnabled;
  @override
  @JsonKey()
  @HiveField(1)
  final bool routineReminders;
  @override
  @JsonKey()
  @HiveField(2)
  final bool itemReminders;
  @override
  @JsonKey()
  @HiveField(3)
  final bool dailyCompletionReminder;
  @override
  @JsonKey()
  @HiveField(4)
  final int reminderMinutesBefore;
  @override
  @JsonKey()
  @HiveField(5)
  final int dailyReminderHour;
// 21시 (오후 9시)
  @override
  @JsonKey()
  @HiveField(6)
  final int dailyReminderMinute;
  @override
  @JsonKey()
  @HiveField(7)
  final bool soundEnabled;
  @override
  @JsonKey()
  @HiveField(8)
  final bool vibrationEnabled;

  @override
  String toString() {
    return 'NotificationSettings(isEnabled: $isEnabled, routineReminders: $routineReminders, itemReminders: $itemReminders, dailyCompletionReminder: $dailyCompletionReminder, reminderMinutesBefore: $reminderMinutesBefore, dailyReminderHour: $dailyReminderHour, dailyReminderMinute: $dailyReminderMinute, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.routineReminders, routineReminders) ||
                other.routineReminders == routineReminders) &&
            (identical(other.itemReminders, itemReminders) ||
                other.itemReminders == itemReminders) &&
            (identical(
                    other.dailyCompletionReminder, dailyCompletionReminder) ||
                other.dailyCompletionReminder == dailyCompletionReminder) &&
            (identical(other.reminderMinutesBefore, reminderMinutesBefore) ||
                other.reminderMinutesBefore == reminderMinutesBefore) &&
            (identical(other.dailyReminderHour, dailyReminderHour) ||
                other.dailyReminderHour == dailyReminderHour) &&
            (identical(other.dailyReminderMinute, dailyReminderMinute) ||
                other.dailyReminderMinute == dailyReminderMinute) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isEnabled,
      routineReminders,
      itemReminders,
      dailyCompletionReminder,
      reminderMinutesBefore,
      dailyReminderHour,
      dailyReminderMinute,
      soundEnabled,
      vibrationEnabled);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith =>
          __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings(
      {@HiveField(0) final bool isEnabled,
      @HiveField(1) final bool routineReminders,
      @HiveField(2) final bool itemReminders,
      @HiveField(3) final bool dailyCompletionReminder,
      @HiveField(4) final int reminderMinutesBefore,
      @HiveField(5) final int dailyReminderHour,
      @HiveField(6) final int dailyReminderMinute,
      @HiveField(7) final bool soundEnabled,
      @HiveField(8) final bool vibrationEnabled}) = _$NotificationSettingsImpl;

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

  @override
  @HiveField(0)
  bool get isEnabled;
  @override
  @HiveField(1)
  bool get routineReminders;
  @override
  @HiveField(2)
  bool get itemReminders;
  @override
  @HiveField(3)
  bool get dailyCompletionReminder;
  @override
  @HiveField(4)
  int get reminderMinutesBefore;
  @override
  @HiveField(5)
  int get dailyReminderHour; // 21시 (오후 9시)
  @override
  @HiveField(6)
  int get dailyReminderMinute;
  @override
  @HiveField(7)
  bool get soundEnabled;
  @override
  @HiveField(8)
  bool get vibrationEnabled;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
