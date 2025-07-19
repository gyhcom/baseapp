// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get job => throw _privateConstructorUsedError;
  List<String> get hobbies => throw _privateConstructorUsedError;
  RoutineConcept get concept => throw _privateConstructorUsedError;
  String get additionalInfo => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String name,
      int age,
      String job,
      List<String> hobbies,
      RoutineConcept concept,
      String additionalInfo,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = null,
    Object? job = null,
    Object? hobbies = null,
    Object? concept = null,
    Object? additionalInfo = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      job: null == job
          ? _value.job
          : job // ignore: cast_nullable_to_non_nullable
              as String,
      hobbies: null == hobbies
          ? _value.hobbies
          : hobbies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      concept: null == concept
          ? _value.concept
          : concept // ignore: cast_nullable_to_non_nullable
              as RoutineConcept,
      additionalInfo: null == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int age,
      String job,
      List<String> hobbies,
      RoutineConcept concept,
      String additionalInfo,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = null,
    Object? job = null,
    Object? hobbies = null,
    Object? concept = null,
    Object? additionalInfo = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      job: null == job
          ? _value.job
          : job // ignore: cast_nullable_to_non_nullable
              as String,
      hobbies: null == hobbies
          ? _value._hobbies
          : hobbies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      concept: null == concept
          ? _value.concept
          : concept // ignore: cast_nullable_to_non_nullable
              as RoutineConcept,
      additionalInfo: null == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.name,
      required this.age,
      required this.job,
      required final List<String> hobbies,
      required this.concept,
      this.additionalInfo = '',
      this.createdAt,
      this.updatedAt})
      : _hobbies = hobbies;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String name;
  @override
  final int age;
  @override
  final String job;
  final List<String> _hobbies;
  @override
  List<String> get hobbies {
    if (_hobbies is EqualUnmodifiableListView) return _hobbies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hobbies);
  }

  @override
  final RoutineConcept concept;
  @override
  @JsonKey()
  final String additionalInfo;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(name: $name, age: $age, job: $job, hobbies: $hobbies, concept: $concept, additionalInfo: $additionalInfo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.job, job) || other.job == job) &&
            const DeepCollectionEquality().equals(other._hobbies, _hobbies) &&
            (identical(other.concept, concept) || other.concept == concept) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      age,
      job,
      const DeepCollectionEquality().hash(_hobbies),
      concept,
      additionalInfo,
      createdAt,
      updatedAt);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String name,
      required final int age,
      required final String job,
      required final List<String> hobbies,
      required final RoutineConcept concept,
      final String additionalInfo,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get name;
  @override
  int get age;
  @override
  String get job;
  @override
  List<String> get hobbies;
  @override
  RoutineConcept get concept;
  @override
  String get additionalInfo;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
