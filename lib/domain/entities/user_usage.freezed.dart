// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserUsage _$UserUsageFromJson(Map<String, dynamic> json) {
  return _UserUsage.fromJson(json);
}

/// @nodoc
mixin _$UserUsage {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  DateTime get date => throw _privateConstructorUsedError; // 날짜 (YYYY-MM-DD 기준)
  @HiveField(2)
  int get dailyGenerations => throw _privateConstructorUsedError; // 일일 AI 생성 횟수
  @HiveField(3)
  int get monthlyGenerations =>
      throw _privateConstructorUsedError; // 월간 AI 생성 횟수
  @HiveField(4)
  int get bonusGenerations => throw _privateConstructorUsedError; // 보너스 생성 횟수
  @HiveField(5)
  bool get isPremium => throw _privateConstructorUsedError; // 프리미엄 사용자 여부
  @HiveField(6)
  DateTime? get premiumExpiryDate =>
      throw _privateConstructorUsedError; // 프리미엄 만료일
  @HiveField(7)
  List<BonusEarned> get bonusHistory =>
      throw _privateConstructorUsedError; // 보너스 획득 내역
  @HiveField(8)
  DateTime? get lastResetDate => throw _privateConstructorUsedError;

  /// Serializes this UserUsage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserUsageCopyWith<UserUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserUsageCopyWith<$Res> {
  factory $UserUsageCopyWith(UserUsage value, $Res Function(UserUsage) then) =
      _$UserUsageCopyWithImpl<$Res, UserUsage>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime date,
      @HiveField(2) int dailyGenerations,
      @HiveField(3) int monthlyGenerations,
      @HiveField(4) int bonusGenerations,
      @HiveField(5) bool isPremium,
      @HiveField(6) DateTime? premiumExpiryDate,
      @HiveField(7) List<BonusEarned> bonusHistory,
      @HiveField(8) DateTime? lastResetDate});
}

/// @nodoc
class _$UserUsageCopyWithImpl<$Res, $Val extends UserUsage>
    implements $UserUsageCopyWith<$Res> {
  _$UserUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dailyGenerations = null,
    Object? monthlyGenerations = null,
    Object? bonusGenerations = null,
    Object? isPremium = null,
    Object? premiumExpiryDate = freezed,
    Object? bonusHistory = null,
    Object? lastResetDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dailyGenerations: null == dailyGenerations
          ? _value.dailyGenerations
          : dailyGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyGenerations: null == monthlyGenerations
          ? _value.monthlyGenerations
          : monthlyGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      bonusGenerations: null == bonusGenerations
          ? _value.bonusGenerations
          : bonusGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      premiumExpiryDate: freezed == premiumExpiryDate
          ? _value.premiumExpiryDate
          : premiumExpiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bonusHistory: null == bonusHistory
          ? _value.bonusHistory
          : bonusHistory // ignore: cast_nullable_to_non_nullable
              as List<BonusEarned>,
      lastResetDate: freezed == lastResetDate
          ? _value.lastResetDate
          : lastResetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserUsageImplCopyWith<$Res>
    implements $UserUsageCopyWith<$Res> {
  factory _$$UserUsageImplCopyWith(
          _$UserUsageImpl value, $Res Function(_$UserUsageImpl) then) =
      __$$UserUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime date,
      @HiveField(2) int dailyGenerations,
      @HiveField(3) int monthlyGenerations,
      @HiveField(4) int bonusGenerations,
      @HiveField(5) bool isPremium,
      @HiveField(6) DateTime? premiumExpiryDate,
      @HiveField(7) List<BonusEarned> bonusHistory,
      @HiveField(8) DateTime? lastResetDate});
}

/// @nodoc
class __$$UserUsageImplCopyWithImpl<$Res>
    extends _$UserUsageCopyWithImpl<$Res, _$UserUsageImpl>
    implements _$$UserUsageImplCopyWith<$Res> {
  __$$UserUsageImplCopyWithImpl(
      _$UserUsageImpl _value, $Res Function(_$UserUsageImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dailyGenerations = null,
    Object? monthlyGenerations = null,
    Object? bonusGenerations = null,
    Object? isPremium = null,
    Object? premiumExpiryDate = freezed,
    Object? bonusHistory = null,
    Object? lastResetDate = freezed,
  }) {
    return _then(_$UserUsageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dailyGenerations: null == dailyGenerations
          ? _value.dailyGenerations
          : dailyGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyGenerations: null == monthlyGenerations
          ? _value.monthlyGenerations
          : monthlyGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      bonusGenerations: null == bonusGenerations
          ? _value.bonusGenerations
          : bonusGenerations // ignore: cast_nullable_to_non_nullable
              as int,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      premiumExpiryDate: freezed == premiumExpiryDate
          ? _value.premiumExpiryDate
          : premiumExpiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bonusHistory: null == bonusHistory
          ? _value._bonusHistory
          : bonusHistory // ignore: cast_nullable_to_non_nullable
              as List<BonusEarned>,
      lastResetDate: freezed == lastResetDate
          ? _value.lastResetDate
          : lastResetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserUsageImpl implements _UserUsage {
  const _$UserUsageImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.date,
      @HiveField(2) this.dailyGenerations = 0,
      @HiveField(3) this.monthlyGenerations = 0,
      @HiveField(4) this.bonusGenerations = 0,
      @HiveField(5) this.isPremium = false,
      @HiveField(6) this.premiumExpiryDate,
      @HiveField(7) final List<BonusEarned> bonusHistory = const [],
      @HiveField(8) this.lastResetDate})
      : _bonusHistory = bonusHistory;

  factory _$UserUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserUsageImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final DateTime date;
// 날짜 (YYYY-MM-DD 기준)
  @override
  @JsonKey()
  @HiveField(2)
  final int dailyGenerations;
// 일일 AI 생성 횟수
  @override
  @JsonKey()
  @HiveField(3)
  final int monthlyGenerations;
// 월간 AI 생성 횟수
  @override
  @JsonKey()
  @HiveField(4)
  final int bonusGenerations;
// 보너스 생성 횟수
  @override
  @JsonKey()
  @HiveField(5)
  final bool isPremium;
// 프리미엄 사용자 여부
  @override
  @HiveField(6)
  final DateTime? premiumExpiryDate;
// 프리미엄 만료일
  final List<BonusEarned> _bonusHistory;
// 프리미엄 만료일
  @override
  @JsonKey()
  @HiveField(7)
  List<BonusEarned> get bonusHistory {
    if (_bonusHistory is EqualUnmodifiableListView) return _bonusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bonusHistory);
  }

// 보너스 획득 내역
  @override
  @HiveField(8)
  final DateTime? lastResetDate;

  @override
  String toString() {
    return 'UserUsage(id: $id, date: $date, dailyGenerations: $dailyGenerations, monthlyGenerations: $monthlyGenerations, bonusGenerations: $bonusGenerations, isPremium: $isPremium, premiumExpiryDate: $premiumExpiryDate, bonusHistory: $bonusHistory, lastResetDate: $lastResetDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserUsageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dailyGenerations, dailyGenerations) ||
                other.dailyGenerations == dailyGenerations) &&
            (identical(other.monthlyGenerations, monthlyGenerations) ||
                other.monthlyGenerations == monthlyGenerations) &&
            (identical(other.bonusGenerations, bonusGenerations) ||
                other.bonusGenerations == bonusGenerations) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.premiumExpiryDate, premiumExpiryDate) ||
                other.premiumExpiryDate == premiumExpiryDate) &&
            const DeepCollectionEquality()
                .equals(other._bonusHistory, _bonusHistory) &&
            (identical(other.lastResetDate, lastResetDate) ||
                other.lastResetDate == lastResetDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      dailyGenerations,
      monthlyGenerations,
      bonusGenerations,
      isPremium,
      premiumExpiryDate,
      const DeepCollectionEquality().hash(_bonusHistory),
      lastResetDate);

  /// Create a copy of UserUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserUsageImplCopyWith<_$UserUsageImpl> get copyWith =>
      __$$UserUsageImplCopyWithImpl<_$UserUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserUsageImplToJson(
      this,
    );
  }
}

abstract class _UserUsage implements UserUsage {
  const factory _UserUsage(
      {@HiveField(0) required final String id,
      @HiveField(1) required final DateTime date,
      @HiveField(2) final int dailyGenerations,
      @HiveField(3) final int monthlyGenerations,
      @HiveField(4) final int bonusGenerations,
      @HiveField(5) final bool isPremium,
      @HiveField(6) final DateTime? premiumExpiryDate,
      @HiveField(7) final List<BonusEarned> bonusHistory,
      @HiveField(8) final DateTime? lastResetDate}) = _$UserUsageImpl;

  factory _UserUsage.fromJson(Map<String, dynamic> json) =
      _$UserUsageImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  DateTime get date; // 날짜 (YYYY-MM-DD 기준)
  @override
  @HiveField(2)
  int get dailyGenerations; // 일일 AI 생성 횟수
  @override
  @HiveField(3)
  int get monthlyGenerations; // 월간 AI 생성 횟수
  @override
  @HiveField(4)
  int get bonusGenerations; // 보너스 생성 횟수
  @override
  @HiveField(5)
  bool get isPremium; // 프리미엄 사용자 여부
  @override
  @HiveField(6)
  DateTime? get premiumExpiryDate; // 프리미엄 만료일
  @override
  @HiveField(7)
  List<BonusEarned> get bonusHistory; // 보너스 획득 내역
  @override
  @HiveField(8)
  DateTime? get lastResetDate;

  /// Create a copy of UserUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserUsageImplCopyWith<_$UserUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BonusEarned _$BonusEarnedFromJson(Map<String, dynamic> json) {
  return _BonusEarned.fromJson(json);
}

/// @nodoc
mixin _$BonusEarned {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  BonusType get type => throw _privateConstructorUsedError;
  @HiveField(2)
  int get amount => throw _privateConstructorUsedError; // 획득한 보너스 생성 횟수
  @HiveField(3)
  DateTime get earnedAt => throw _privateConstructorUsedError;
  @HiveField(4)
  String get description => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isUsed => throw _privateConstructorUsedError;

  /// Serializes this BonusEarned to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BonusEarned
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BonusEarnedCopyWith<BonusEarned> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BonusEarnedCopyWith<$Res> {
  factory $BonusEarnedCopyWith(
          BonusEarned value, $Res Function(BonusEarned) then) =
      _$BonusEarnedCopyWithImpl<$Res, BonusEarned>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) BonusType type,
      @HiveField(2) int amount,
      @HiveField(3) DateTime earnedAt,
      @HiveField(4) String description,
      @HiveField(5) bool isUsed});
}

/// @nodoc
class _$BonusEarnedCopyWithImpl<$Res, $Val extends BonusEarned>
    implements $BonusEarnedCopyWith<$Res> {
  _$BonusEarnedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BonusEarned
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? earnedAt = null,
    Object? description = null,
    Object? isUsed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BonusType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isUsed: null == isUsed
          ? _value.isUsed
          : isUsed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BonusEarnedImplCopyWith<$Res>
    implements $BonusEarnedCopyWith<$Res> {
  factory _$$BonusEarnedImplCopyWith(
          _$BonusEarnedImpl value, $Res Function(_$BonusEarnedImpl) then) =
      __$$BonusEarnedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) BonusType type,
      @HiveField(2) int amount,
      @HiveField(3) DateTime earnedAt,
      @HiveField(4) String description,
      @HiveField(5) bool isUsed});
}

/// @nodoc
class __$$BonusEarnedImplCopyWithImpl<$Res>
    extends _$BonusEarnedCopyWithImpl<$Res, _$BonusEarnedImpl>
    implements _$$BonusEarnedImplCopyWith<$Res> {
  __$$BonusEarnedImplCopyWithImpl(
      _$BonusEarnedImpl _value, $Res Function(_$BonusEarnedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BonusEarned
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? earnedAt = null,
    Object? description = null,
    Object? isUsed = null,
  }) {
    return _then(_$BonusEarnedImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BonusType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      earnedAt: null == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isUsed: null == isUsed
          ? _value.isUsed
          : isUsed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BonusEarnedImpl implements _BonusEarned {
  const _$BonusEarnedImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.type,
      @HiveField(2) required this.amount,
      @HiveField(3) required this.earnedAt,
      @HiveField(4) this.description = '',
      @HiveField(5) this.isUsed = false});

  factory _$BonusEarnedImpl.fromJson(Map<String, dynamic> json) =>
      _$$BonusEarnedImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final BonusType type;
  @override
  @HiveField(2)
  final int amount;
// 획득한 보너스 생성 횟수
  @override
  @HiveField(3)
  final DateTime earnedAt;
  @override
  @JsonKey()
  @HiveField(4)
  final String description;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isUsed;

  @override
  String toString() {
    return 'BonusEarned(id: $id, type: $type, amount: $amount, earnedAt: $earnedAt, description: $description, isUsed: $isUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BonusEarnedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isUsed, isUsed) || other.isUsed == isUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, amount, earnedAt, description, isUsed);

  /// Create a copy of BonusEarned
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BonusEarnedImplCopyWith<_$BonusEarnedImpl> get copyWith =>
      __$$BonusEarnedImplCopyWithImpl<_$BonusEarnedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BonusEarnedImplToJson(
      this,
    );
  }
}

abstract class _BonusEarned implements BonusEarned {
  const factory _BonusEarned(
      {@HiveField(0) required final String id,
      @HiveField(1) required final BonusType type,
      @HiveField(2) required final int amount,
      @HiveField(3) required final DateTime earnedAt,
      @HiveField(4) final String description,
      @HiveField(5) final bool isUsed}) = _$BonusEarnedImpl;

  factory _BonusEarned.fromJson(Map<String, dynamic> json) =
      _$BonusEarnedImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  BonusType get type;
  @override
  @HiveField(2)
  int get amount; // 획득한 보너스 생성 횟수
  @override
  @HiveField(3)
  DateTime get earnedAt;
  @override
  @HiveField(4)
  String get description;
  @override
  @HiveField(5)
  bool get isUsed;

  /// Create a copy of BonusEarned
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BonusEarnedImplCopyWith<_$BonusEarnedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
