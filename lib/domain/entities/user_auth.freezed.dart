// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserAuth _$UserAuthFromJson(Map<String, dynamic> json) {
  return _UserAuth.fromJson(json);
}

/// @nodoc
mixin _$UserAuth {
  @HiveField(0)
  String get uid => throw _privateConstructorUsedError;
  @HiveField(1)
  String get email => throw _privateConstructorUsedError;
  @HiveField(2)
  String get displayName => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get photoURL => throw _privateConstructorUsedError;
  @HiveField(4)
  UserAuthProvider get provider => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isAnonymous => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get lastSignInAt => throw _privateConstructorUsedError;

  /// Serializes this UserAuth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserAuthCopyWith<UserAuth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAuthCopyWith<$Res> {
  factory $UserAuthCopyWith(UserAuth value, $Res Function(UserAuth) then) =
      _$UserAuthCopyWithImpl<$Res, UserAuth>;
  @useResult
  $Res call(
      {@HiveField(0) String uid,
      @HiveField(1) String email,
      @HiveField(2) String displayName,
      @HiveField(3) String? photoURL,
      @HiveField(4) UserAuthProvider provider,
      @HiveField(5) bool isAnonymous,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime? lastSignInAt});
}

/// @nodoc
class _$UserAuthCopyWithImpl<$Res, $Val extends UserAuth>
    implements $UserAuthCopyWith<$Res> {
  _$UserAuthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? photoURL = freezed,
    Object? provider = null,
    Object? isAnonymous = null,
    Object? createdAt = null,
    Object? lastSignInAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as UserAuthProvider,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSignInAt: freezed == lastSignInAt
          ? _value.lastSignInAt
          : lastSignInAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAuthImplCopyWith<$Res>
    implements $UserAuthCopyWith<$Res> {
  factory _$$UserAuthImplCopyWith(
          _$UserAuthImpl value, $Res Function(_$UserAuthImpl) then) =
      __$$UserAuthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String uid,
      @HiveField(1) String email,
      @HiveField(2) String displayName,
      @HiveField(3) String? photoURL,
      @HiveField(4) UserAuthProvider provider,
      @HiveField(5) bool isAnonymous,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime? lastSignInAt});
}

/// @nodoc
class __$$UserAuthImplCopyWithImpl<$Res>
    extends _$UserAuthCopyWithImpl<$Res, _$UserAuthImpl>
    implements _$$UserAuthImplCopyWith<$Res> {
  __$$UserAuthImplCopyWithImpl(
      _$UserAuthImpl _value, $Res Function(_$UserAuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? photoURL = freezed,
    Object? provider = null,
    Object? isAnonymous = null,
    Object? createdAt = null,
    Object? lastSignInAt = freezed,
  }) {
    return _then(_$UserAuthImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as UserAuthProvider,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSignInAt: freezed == lastSignInAt
          ? _value.lastSignInAt
          : lastSignInAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAuthImpl implements _UserAuth {
  const _$UserAuthImpl(
      {@HiveField(0) required this.uid,
      @HiveField(1) required this.email,
      @HiveField(2) required this.displayName,
      @HiveField(3) this.photoURL,
      @HiveField(4) required this.provider,
      @HiveField(5) this.isAnonymous = false,
      @HiveField(6) required this.createdAt,
      @HiveField(7) this.lastSignInAt});

  factory _$UserAuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAuthImplFromJson(json);

  @override
  @HiveField(0)
  final String uid;
  @override
  @HiveField(1)
  final String email;
  @override
  @HiveField(2)
  final String displayName;
  @override
  @HiveField(3)
  final String? photoURL;
  @override
  @HiveField(4)
  final UserAuthProvider provider;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isAnonymous;
  @override
  @HiveField(6)
  final DateTime createdAt;
  @override
  @HiveField(7)
  final DateTime? lastSignInAt;

  @override
  String toString() {
    return 'UserAuth(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, provider: $provider, isAnonymous: $isAnonymous, createdAt: $createdAt, lastSignInAt: $lastSignInAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAuthImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastSignInAt, lastSignInAt) ||
                other.lastSignInAt == lastSignInAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, email, displayName,
      photoURL, provider, isAnonymous, createdAt, lastSignInAt);

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAuthImplCopyWith<_$UserAuthImpl> get copyWith =>
      __$$UserAuthImplCopyWithImpl<_$UserAuthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAuthImplToJson(
      this,
    );
  }
}

abstract class _UserAuth implements UserAuth {
  const factory _UserAuth(
      {@HiveField(0) required final String uid,
      @HiveField(1) required final String email,
      @HiveField(2) required final String displayName,
      @HiveField(3) final String? photoURL,
      @HiveField(4) required final UserAuthProvider provider,
      @HiveField(5) final bool isAnonymous,
      @HiveField(6) required final DateTime createdAt,
      @HiveField(7) final DateTime? lastSignInAt}) = _$UserAuthImpl;

  factory _UserAuth.fromJson(Map<String, dynamic> json) =
      _$UserAuthImpl.fromJson;

  @override
  @HiveField(0)
  String get uid;
  @override
  @HiveField(1)
  String get email;
  @override
  @HiveField(2)
  String get displayName;
  @override
  @HiveField(3)
  String? get photoURL;
  @override
  @HiveField(4)
  UserAuthProvider get provider;
  @override
  @HiveField(5)
  bool get isAnonymous;
  @override
  @HiveField(6)
  DateTime get createdAt;
  @override
  @HiveField(7)
  DateTime? get lastSignInAt;

  /// Create a copy of UserAuth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserAuthImplCopyWith<_$UserAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
