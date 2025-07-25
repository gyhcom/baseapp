// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_behavior_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserBehaviorLog _$UserBehaviorLogFromJson(Map<String, dynamic> json) {
  return _UserBehaviorLog.fromJson(json);
}

/// @nodoc
mixin _$UserBehaviorLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get routineId => throw _privateConstructorUsedError;
  String get routineItemId => throw _privateConstructorUsedError;
  BehaviorType get behaviorType => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError; // 컨텍스트 정보
  int get dayOfWeek => throw _privateConstructorUsedError; // 1=월요일, 7=일요일
  int get hourOfDay => throw _privateConstructorUsedError; // 0-23
  String? get weather => throw _privateConstructorUsedError; // 날씨 정보 (선택)
  String? get location => throw _privateConstructorUsedError; // 위치 정보 (선택)
// 알림 관련
  DateTime? get notificationSentAt =>
      throw _privateConstructorUsedError; // 알림 발송 시간
  Duration? get responseDelay =>
      throw _privateConstructorUsedError; // 알림 후 응답까지 시간
// 추가 메타데이터
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  /// Serializes this UserBehaviorLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBehaviorLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBehaviorLogCopyWith<UserBehaviorLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBehaviorLogCopyWith<$Res> {
  factory $UserBehaviorLogCopyWith(
          UserBehaviorLog value, $Res Function(UserBehaviorLog) then) =
      _$UserBehaviorLogCopyWithImpl<$Res, UserBehaviorLog>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String routineId,
      String routineItemId,
      BehaviorType behaviorType,
      DateTime timestamp,
      int dayOfWeek,
      int hourOfDay,
      String? weather,
      String? location,
      DateTime? notificationSentAt,
      Duration? responseDelay,
      Map<String, dynamic>? metadata,
      bool isSynced});
}

/// @nodoc
class _$UserBehaviorLogCopyWithImpl<$Res, $Val extends UserBehaviorLog>
    implements $UserBehaviorLogCopyWith<$Res> {
  _$UserBehaviorLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBehaviorLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? routineId = null,
    Object? routineItemId = null,
    Object? behaviorType = null,
    Object? timestamp = null,
    Object? dayOfWeek = null,
    Object? hourOfDay = null,
    Object? weather = freezed,
    Object? location = freezed,
    Object? notificationSentAt = freezed,
    Object? responseDelay = freezed,
    Object? metadata = freezed,
    Object? isSynced = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      routineItemId: null == routineItemId
          ? _value.routineItemId
          : routineItemId // ignore: cast_nullable_to_non_nullable
              as String,
      behaviorType: null == behaviorType
          ? _value.behaviorType
          : behaviorType // ignore: cast_nullable_to_non_nullable
              as BehaviorType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      hourOfDay: null == hourOfDay
          ? _value.hourOfDay
          : hourOfDay // ignore: cast_nullable_to_non_nullable
              as int,
      weather: freezed == weather
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationSentAt: freezed == notificationSentAt
          ? _value.notificationSentAt
          : notificationSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      responseDelay: freezed == responseDelay
          ? _value.responseDelay
          : responseDelay // ignore: cast_nullable_to_non_nullable
              as Duration?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserBehaviorLogImplCopyWith<$Res>
    implements $UserBehaviorLogCopyWith<$Res> {
  factory _$$UserBehaviorLogImplCopyWith(_$UserBehaviorLogImpl value,
          $Res Function(_$UserBehaviorLogImpl) then) =
      __$$UserBehaviorLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String routineId,
      String routineItemId,
      BehaviorType behaviorType,
      DateTime timestamp,
      int dayOfWeek,
      int hourOfDay,
      String? weather,
      String? location,
      DateTime? notificationSentAt,
      Duration? responseDelay,
      Map<String, dynamic>? metadata,
      bool isSynced});
}

/// @nodoc
class __$$UserBehaviorLogImplCopyWithImpl<$Res>
    extends _$UserBehaviorLogCopyWithImpl<$Res, _$UserBehaviorLogImpl>
    implements _$$UserBehaviorLogImplCopyWith<$Res> {
  __$$UserBehaviorLogImplCopyWithImpl(
      _$UserBehaviorLogImpl _value, $Res Function(_$UserBehaviorLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserBehaviorLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? routineId = null,
    Object? routineItemId = null,
    Object? behaviorType = null,
    Object? timestamp = null,
    Object? dayOfWeek = null,
    Object? hourOfDay = null,
    Object? weather = freezed,
    Object? location = freezed,
    Object? notificationSentAt = freezed,
    Object? responseDelay = freezed,
    Object? metadata = freezed,
    Object? isSynced = null,
  }) {
    return _then(_$UserBehaviorLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      routineItemId: null == routineItemId
          ? _value.routineItemId
          : routineItemId // ignore: cast_nullable_to_non_nullable
              as String,
      behaviorType: null == behaviorType
          ? _value.behaviorType
          : behaviorType // ignore: cast_nullable_to_non_nullable
              as BehaviorType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      hourOfDay: null == hourOfDay
          ? _value.hourOfDay
          : hourOfDay // ignore: cast_nullable_to_non_nullable
              as int,
      weather: freezed == weather
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationSentAt: freezed == notificationSentAt
          ? _value.notificationSentAt
          : notificationSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      responseDelay: freezed == responseDelay
          ? _value.responseDelay
          : responseDelay // ignore: cast_nullable_to_non_nullable
              as Duration?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBehaviorLogImpl implements _UserBehaviorLog {
  const _$UserBehaviorLogImpl(
      {required this.id,
      required this.userId,
      required this.routineId,
      required this.routineItemId,
      required this.behaviorType,
      required this.timestamp,
      required this.dayOfWeek,
      required this.hourOfDay,
      this.weather,
      this.location,
      this.notificationSentAt,
      this.responseDelay,
      final Map<String, dynamic>? metadata,
      this.isSynced = false})
      : _metadata = metadata;

  factory _$UserBehaviorLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBehaviorLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String routineId;
  @override
  final String routineItemId;
  @override
  final BehaviorType behaviorType;
  @override
  final DateTime timestamp;
// 컨텍스트 정보
  @override
  final int dayOfWeek;
// 1=월요일, 7=일요일
  @override
  final int hourOfDay;
// 0-23
  @override
  final String? weather;
// 날씨 정보 (선택)
  @override
  final String? location;
// 위치 정보 (선택)
// 알림 관련
  @override
  final DateTime? notificationSentAt;
// 알림 발송 시간
  @override
  final Duration? responseDelay;
// 알림 후 응답까지 시간
// 추가 메타데이터
  final Map<String, dynamic>? _metadata;
// 알림 후 응답까지 시간
// 추가 메타데이터
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'UserBehaviorLog(id: $id, userId: $userId, routineId: $routineId, routineItemId: $routineItemId, behaviorType: $behaviorType, timestamp: $timestamp, dayOfWeek: $dayOfWeek, hourOfDay: $hourOfDay, weather: $weather, location: $location, notificationSentAt: $notificationSentAt, responseDelay: $responseDelay, metadata: $metadata, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBehaviorLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.routineItemId, routineItemId) ||
                other.routineItemId == routineItemId) &&
            (identical(other.behaviorType, behaviorType) ||
                other.behaviorType == behaviorType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.hourOfDay, hourOfDay) ||
                other.hourOfDay == hourOfDay) &&
            (identical(other.weather, weather) || other.weather == weather) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.notificationSentAt, notificationSentAt) ||
                other.notificationSentAt == notificationSentAt) &&
            (identical(other.responseDelay, responseDelay) ||
                other.responseDelay == responseDelay) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      routineId,
      routineItemId,
      behaviorType,
      timestamp,
      dayOfWeek,
      hourOfDay,
      weather,
      location,
      notificationSentAt,
      responseDelay,
      const DeepCollectionEquality().hash(_metadata),
      isSynced);

  /// Create a copy of UserBehaviorLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBehaviorLogImplCopyWith<_$UserBehaviorLogImpl> get copyWith =>
      __$$UserBehaviorLogImplCopyWithImpl<_$UserBehaviorLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBehaviorLogImplToJson(
      this,
    );
  }
}

abstract class _UserBehaviorLog implements UserBehaviorLog {
  const factory _UserBehaviorLog(
      {required final String id,
      required final String userId,
      required final String routineId,
      required final String routineItemId,
      required final BehaviorType behaviorType,
      required final DateTime timestamp,
      required final int dayOfWeek,
      required final int hourOfDay,
      final String? weather,
      final String? location,
      final DateTime? notificationSentAt,
      final Duration? responseDelay,
      final Map<String, dynamic>? metadata,
      final bool isSynced}) = _$UserBehaviorLogImpl;

  factory _UserBehaviorLog.fromJson(Map<String, dynamic> json) =
      _$UserBehaviorLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get routineId;
  @override
  String get routineItemId;
  @override
  BehaviorType get behaviorType;
  @override
  DateTime get timestamp; // 컨텍스트 정보
  @override
  int get dayOfWeek; // 1=월요일, 7=일요일
  @override
  int get hourOfDay; // 0-23
  @override
  String? get weather; // 날씨 정보 (선택)
  @override
  String? get location; // 위치 정보 (선택)
// 알림 관련
  @override
  DateTime? get notificationSentAt; // 알림 발송 시간
  @override
  Duration? get responseDelay; // 알림 후 응답까지 시간
// 추가 메타데이터
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isSynced;

  /// Create a copy of UserBehaviorLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBehaviorLogImplCopyWith<_$UserBehaviorLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BehaviorPattern _$BehaviorPatternFromJson(Map<String, dynamic> json) {
  return _BehaviorPattern.fromJson(json);
}

/// @nodoc
mixin _$BehaviorPattern {
  String get userId => throw _privateConstructorUsedError;
  String get routineId => throw _privateConstructorUsedError; // 시간 패턴
  Map<int, double> get hourlySuccessRate =>
      throw _privateConstructorUsedError; // 시간별 성공률 0-23
  Map<int, double> get weeklySuccessRate =>
      throw _privateConstructorUsedError; // 요일별 성공률 1-7
// 알림 반응 패턴
  Duration get averageResponseTime =>
      throw _privateConstructorUsedError; // 평균 응답 시간
  double get notificationEffectiveness =>
      throw _privateConstructorUsedError; // 알림 효과성 (0.0-1.0)
// 연속성 패턴
  int get currentStreak => throw _privateConstructorUsedError; // 현재 연속 성공
  int get longestStreak => throw _privateConstructorUsedError; // 최장 연속 성공
  double get overallSuccessRate => throw _privateConstructorUsedError; // 전체 성공률
// 예측된 최적 시간
  List<OptimalTime> get suggestedTimes => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  int get totalDataPoints => throw _privateConstructorUsedError;

  /// Serializes this BehaviorPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BehaviorPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BehaviorPatternCopyWith<BehaviorPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BehaviorPatternCopyWith<$Res> {
  factory $BehaviorPatternCopyWith(
          BehaviorPattern value, $Res Function(BehaviorPattern) then) =
      _$BehaviorPatternCopyWithImpl<$Res, BehaviorPattern>;
  @useResult
  $Res call(
      {String userId,
      String routineId,
      Map<int, double> hourlySuccessRate,
      Map<int, double> weeklySuccessRate,
      Duration averageResponseTime,
      double notificationEffectiveness,
      int currentStreak,
      int longestStreak,
      double overallSuccessRate,
      List<OptimalTime> suggestedTimes,
      DateTime lastUpdated,
      int totalDataPoints});
}

/// @nodoc
class _$BehaviorPatternCopyWithImpl<$Res, $Val extends BehaviorPattern>
    implements $BehaviorPatternCopyWith<$Res> {
  _$BehaviorPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BehaviorPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? routineId = null,
    Object? hourlySuccessRate = null,
    Object? weeklySuccessRate = null,
    Object? averageResponseTime = null,
    Object? notificationEffectiveness = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? overallSuccessRate = null,
    Object? suggestedTimes = null,
    Object? lastUpdated = null,
    Object? totalDataPoints = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      hourlySuccessRate: null == hourlySuccessRate
          ? _value.hourlySuccessRate
          : hourlySuccessRate // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      weeklySuccessRate: null == weeklySuccessRate
          ? _value.weeklySuccessRate
          : weeklySuccessRate // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      averageResponseTime: null == averageResponseTime
          ? _value.averageResponseTime
          : averageResponseTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      notificationEffectiveness: null == notificationEffectiveness
          ? _value.notificationEffectiveness
          : notificationEffectiveness // ignore: cast_nullable_to_non_nullable
              as double,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      overallSuccessRate: null == overallSuccessRate
          ? _value.overallSuccessRate
          : overallSuccessRate // ignore: cast_nullable_to_non_nullable
              as double,
      suggestedTimes: null == suggestedTimes
          ? _value.suggestedTimes
          : suggestedTimes // ignore: cast_nullable_to_non_nullable
              as List<OptimalTime>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalDataPoints: null == totalDataPoints
          ? _value.totalDataPoints
          : totalDataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BehaviorPatternImplCopyWith<$Res>
    implements $BehaviorPatternCopyWith<$Res> {
  factory _$$BehaviorPatternImplCopyWith(_$BehaviorPatternImpl value,
          $Res Function(_$BehaviorPatternImpl) then) =
      __$$BehaviorPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String routineId,
      Map<int, double> hourlySuccessRate,
      Map<int, double> weeklySuccessRate,
      Duration averageResponseTime,
      double notificationEffectiveness,
      int currentStreak,
      int longestStreak,
      double overallSuccessRate,
      List<OptimalTime> suggestedTimes,
      DateTime lastUpdated,
      int totalDataPoints});
}

/// @nodoc
class __$$BehaviorPatternImplCopyWithImpl<$Res>
    extends _$BehaviorPatternCopyWithImpl<$Res, _$BehaviorPatternImpl>
    implements _$$BehaviorPatternImplCopyWith<$Res> {
  __$$BehaviorPatternImplCopyWithImpl(
      _$BehaviorPatternImpl _value, $Res Function(_$BehaviorPatternImpl) _then)
      : super(_value, _then);

  /// Create a copy of BehaviorPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? routineId = null,
    Object? hourlySuccessRate = null,
    Object? weeklySuccessRate = null,
    Object? averageResponseTime = null,
    Object? notificationEffectiveness = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? overallSuccessRate = null,
    Object? suggestedTimes = null,
    Object? lastUpdated = null,
    Object? totalDataPoints = null,
  }) {
    return _then(_$BehaviorPatternImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      hourlySuccessRate: null == hourlySuccessRate
          ? _value._hourlySuccessRate
          : hourlySuccessRate // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      weeklySuccessRate: null == weeklySuccessRate
          ? _value._weeklySuccessRate
          : weeklySuccessRate // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      averageResponseTime: null == averageResponseTime
          ? _value.averageResponseTime
          : averageResponseTime // ignore: cast_nullable_to_non_nullable
              as Duration,
      notificationEffectiveness: null == notificationEffectiveness
          ? _value.notificationEffectiveness
          : notificationEffectiveness // ignore: cast_nullable_to_non_nullable
              as double,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      overallSuccessRate: null == overallSuccessRate
          ? _value.overallSuccessRate
          : overallSuccessRate // ignore: cast_nullable_to_non_nullable
              as double,
      suggestedTimes: null == suggestedTimes
          ? _value._suggestedTimes
          : suggestedTimes // ignore: cast_nullable_to_non_nullable
              as List<OptimalTime>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalDataPoints: null == totalDataPoints
          ? _value.totalDataPoints
          : totalDataPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BehaviorPatternImpl implements _BehaviorPattern {
  const _$BehaviorPatternImpl(
      {required this.userId,
      required this.routineId,
      required final Map<int, double> hourlySuccessRate,
      required final Map<int, double> weeklySuccessRate,
      required this.averageResponseTime,
      required this.notificationEffectiveness,
      required this.currentStreak,
      required this.longestStreak,
      required this.overallSuccessRate,
      required final List<OptimalTime> suggestedTimes,
      required this.lastUpdated,
      required this.totalDataPoints})
      : _hourlySuccessRate = hourlySuccessRate,
        _weeklySuccessRate = weeklySuccessRate,
        _suggestedTimes = suggestedTimes;

  factory _$BehaviorPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$BehaviorPatternImplFromJson(json);

  @override
  final String userId;
  @override
  final String routineId;
// 시간 패턴
  final Map<int, double> _hourlySuccessRate;
// 시간 패턴
  @override
  Map<int, double> get hourlySuccessRate {
    if (_hourlySuccessRate is EqualUnmodifiableMapView)
      return _hourlySuccessRate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hourlySuccessRate);
  }

// 시간별 성공률 0-23
  final Map<int, double> _weeklySuccessRate;
// 시간별 성공률 0-23
  @override
  Map<int, double> get weeklySuccessRate {
    if (_weeklySuccessRate is EqualUnmodifiableMapView)
      return _weeklySuccessRate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weeklySuccessRate);
  }

// 요일별 성공률 1-7
// 알림 반응 패턴
  @override
  final Duration averageResponseTime;
// 평균 응답 시간
  @override
  final double notificationEffectiveness;
// 알림 효과성 (0.0-1.0)
// 연속성 패턴
  @override
  final int currentStreak;
// 현재 연속 성공
  @override
  final int longestStreak;
// 최장 연속 성공
  @override
  final double overallSuccessRate;
// 전체 성공률
// 예측된 최적 시간
  final List<OptimalTime> _suggestedTimes;
// 전체 성공률
// 예측된 최적 시간
  @override
  List<OptimalTime> get suggestedTimes {
    if (_suggestedTimes is EqualUnmodifiableListView) return _suggestedTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedTimes);
  }

  @override
  final DateTime lastUpdated;
  @override
  final int totalDataPoints;

  @override
  String toString() {
    return 'BehaviorPattern(userId: $userId, routineId: $routineId, hourlySuccessRate: $hourlySuccessRate, weeklySuccessRate: $weeklySuccessRate, averageResponseTime: $averageResponseTime, notificationEffectiveness: $notificationEffectiveness, currentStreak: $currentStreak, longestStreak: $longestStreak, overallSuccessRate: $overallSuccessRate, suggestedTimes: $suggestedTimes, lastUpdated: $lastUpdated, totalDataPoints: $totalDataPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BehaviorPatternImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            const DeepCollectionEquality()
                .equals(other._hourlySuccessRate, _hourlySuccessRate) &&
            const DeepCollectionEquality()
                .equals(other._weeklySuccessRate, _weeklySuccessRate) &&
            (identical(other.averageResponseTime, averageResponseTime) ||
                other.averageResponseTime == averageResponseTime) &&
            (identical(other.notificationEffectiveness,
                    notificationEffectiveness) ||
                other.notificationEffectiveness == notificationEffectiveness) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.overallSuccessRate, overallSuccessRate) ||
                other.overallSuccessRate == overallSuccessRate) &&
            const DeepCollectionEquality()
                .equals(other._suggestedTimes, _suggestedTimes) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.totalDataPoints, totalDataPoints) ||
                other.totalDataPoints == totalDataPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      routineId,
      const DeepCollectionEquality().hash(_hourlySuccessRate),
      const DeepCollectionEquality().hash(_weeklySuccessRate),
      averageResponseTime,
      notificationEffectiveness,
      currentStreak,
      longestStreak,
      overallSuccessRate,
      const DeepCollectionEquality().hash(_suggestedTimes),
      lastUpdated,
      totalDataPoints);

  /// Create a copy of BehaviorPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BehaviorPatternImplCopyWith<_$BehaviorPatternImpl> get copyWith =>
      __$$BehaviorPatternImplCopyWithImpl<_$BehaviorPatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BehaviorPatternImplToJson(
      this,
    );
  }
}

abstract class _BehaviorPattern implements BehaviorPattern {
  const factory _BehaviorPattern(
      {required final String userId,
      required final String routineId,
      required final Map<int, double> hourlySuccessRate,
      required final Map<int, double> weeklySuccessRate,
      required final Duration averageResponseTime,
      required final double notificationEffectiveness,
      required final int currentStreak,
      required final int longestStreak,
      required final double overallSuccessRate,
      required final List<OptimalTime> suggestedTimes,
      required final DateTime lastUpdated,
      required final int totalDataPoints}) = _$BehaviorPatternImpl;

  factory _BehaviorPattern.fromJson(Map<String, dynamic> json) =
      _$BehaviorPatternImpl.fromJson;

  @override
  String get userId;
  @override
  String get routineId; // 시간 패턴
  @override
  Map<int, double> get hourlySuccessRate; // 시간별 성공률 0-23
  @override
  Map<int, double> get weeklySuccessRate; // 요일별 성공률 1-7
// 알림 반응 패턴
  @override
  Duration get averageResponseTime; // 평균 응답 시간
  @override
  double get notificationEffectiveness; // 알림 효과성 (0.0-1.0)
// 연속성 패턴
  @override
  int get currentStreak; // 현재 연속 성공
  @override
  int get longestStreak; // 최장 연속 성공
  @override
  double get overallSuccessRate; // 전체 성공률
// 예측된 최적 시간
  @override
  List<OptimalTime> get suggestedTimes;
  @override
  DateTime get lastUpdated;
  @override
  int get totalDataPoints;

  /// Create a copy of BehaviorPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BehaviorPatternImplCopyWith<_$BehaviorPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OptimalTime _$OptimalTimeFromJson(Map<String, dynamic> json) {
  return _OptimalTime.fromJson(json);
}

/// @nodoc
mixin _$OptimalTime {
  int get dayOfWeek => throw _privateConstructorUsedError;
  int get hour => throw _privateConstructorUsedError;
  double get successProbability =>
      throw _privateConstructorUsedError; // 성공 확률 0.0-1.0
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this OptimalTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OptimalTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptimalTimeCopyWith<OptimalTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimalTimeCopyWith<$Res> {
  factory $OptimalTimeCopyWith(
          OptimalTime value, $Res Function(OptimalTime) then) =
      _$OptimalTimeCopyWithImpl<$Res, OptimalTime>;
  @useResult
  $Res call(
      {int dayOfWeek, int hour, double successProbability, String reason});
}

/// @nodoc
class _$OptimalTimeCopyWithImpl<$Res, $Val extends OptimalTime>
    implements $OptimalTimeCopyWith<$Res> {
  _$OptimalTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptimalTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? hour = null,
    Object? successProbability = null,
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      successProbability: null == successProbability
          ? _value.successProbability
          : successProbability // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OptimalTimeImplCopyWith<$Res>
    implements $OptimalTimeCopyWith<$Res> {
  factory _$$OptimalTimeImplCopyWith(
          _$OptimalTimeImpl value, $Res Function(_$OptimalTimeImpl) then) =
      __$$OptimalTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dayOfWeek, int hour, double successProbability, String reason});
}

/// @nodoc
class __$$OptimalTimeImplCopyWithImpl<$Res>
    extends _$OptimalTimeCopyWithImpl<$Res, _$OptimalTimeImpl>
    implements _$$OptimalTimeImplCopyWith<$Res> {
  __$$OptimalTimeImplCopyWithImpl(
      _$OptimalTimeImpl _value, $Res Function(_$OptimalTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of OptimalTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? hour = null,
    Object? successProbability = null,
    Object? reason = null,
  }) {
    return _then(_$OptimalTimeImpl(
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      successProbability: null == successProbability
          ? _value.successProbability
          : successProbability // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OptimalTimeImpl implements _OptimalTime {
  const _$OptimalTimeImpl(
      {required this.dayOfWeek,
      required this.hour,
      required this.successProbability,
      required this.reason});

  factory _$OptimalTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptimalTimeImplFromJson(json);

  @override
  final int dayOfWeek;
  @override
  final int hour;
  @override
  final double successProbability;
// 성공 확률 0.0-1.0
  @override
  final String reason;

  @override
  String toString() {
    return 'OptimalTime(dayOfWeek: $dayOfWeek, hour: $hour, successProbability: $successProbability, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptimalTimeImpl &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.successProbability, successProbability) ||
                other.successProbability == successProbability) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dayOfWeek, hour, successProbability, reason);

  /// Create a copy of OptimalTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptimalTimeImplCopyWith<_$OptimalTimeImpl> get copyWith =>
      __$$OptimalTimeImplCopyWithImpl<_$OptimalTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OptimalTimeImplToJson(
      this,
    );
  }
}

abstract class _OptimalTime implements OptimalTime {
  const factory _OptimalTime(
      {required final int dayOfWeek,
      required final int hour,
      required final double successProbability,
      required final String reason}) = _$OptimalTimeImpl;

  factory _OptimalTime.fromJson(Map<String, dynamic> json) =
      _$OptimalTimeImpl.fromJson;

  @override
  int get dayOfWeek;
  @override
  int get hour;
  @override
  double get successProbability; // 성공 확률 0.0-1.0
  @override
  String get reason;

  /// Create a copy of OptimalTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptimalTimeImplCopyWith<_$OptimalTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
