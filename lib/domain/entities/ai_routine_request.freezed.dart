// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_routine_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIRoutineRequest _$AIRoutineRequestFromJson(Map<String, dynamic> json) {
  return _AIRoutineRequest.fromJson(json);
}

/// @nodoc
mixin _$AIRoutineRequest {
  String get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get job => throw _privateConstructorUsedError;
  List<String> get hobbies => throw _privateConstructorUsedError;
  RoutineConcept get concept => throw _privateConstructorUsedError;
  String get additionalInfo => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError; // 응답 언어
  int get durationDays => throw _privateConstructorUsedError;

  /// Serializes this AIRoutineRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIRoutineRequestCopyWith<AIRoutineRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIRoutineRequestCopyWith<$Res> {
  factory $AIRoutineRequestCopyWith(
          AIRoutineRequest value, $Res Function(AIRoutineRequest) then) =
      _$AIRoutineRequestCopyWithImpl<$Res, AIRoutineRequest>;
  @useResult
  $Res call(
      {String name,
      int age,
      String job,
      List<String> hobbies,
      RoutineConcept concept,
      String additionalInfo,
      String language,
      int durationDays});
}

/// @nodoc
class _$AIRoutineRequestCopyWithImpl<$Res, $Val extends AIRoutineRequest>
    implements $AIRoutineRequestCopyWith<$Res> {
  _$AIRoutineRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIRoutineRequest
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
    Object? language = null,
    Object? durationDays = null,
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
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIRoutineRequestImplCopyWith<$Res>
    implements $AIRoutineRequestCopyWith<$Res> {
  factory _$$AIRoutineRequestImplCopyWith(_$AIRoutineRequestImpl value,
          $Res Function(_$AIRoutineRequestImpl) then) =
      __$$AIRoutineRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int age,
      String job,
      List<String> hobbies,
      RoutineConcept concept,
      String additionalInfo,
      String language,
      int durationDays});
}

/// @nodoc
class __$$AIRoutineRequestImplCopyWithImpl<$Res>
    extends _$AIRoutineRequestCopyWithImpl<$Res, _$AIRoutineRequestImpl>
    implements _$$AIRoutineRequestImplCopyWith<$Res> {
  __$$AIRoutineRequestImplCopyWithImpl(_$AIRoutineRequestImpl _value,
      $Res Function(_$AIRoutineRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIRoutineRequest
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
    Object? language = null,
    Object? durationDays = null,
  }) {
    return _then(_$AIRoutineRequestImpl(
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
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      durationDays: null == durationDays
          ? _value.durationDays
          : durationDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIRoutineRequestImpl implements _AIRoutineRequest {
  const _$AIRoutineRequestImpl(
      {required this.name,
      required this.age,
      required this.job,
      required final List<String> hobbies,
      required this.concept,
      this.additionalInfo = '',
      this.language = 'ko',
      this.durationDays = 7})
      : _hobbies = hobbies;

  factory _$AIRoutineRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIRoutineRequestImplFromJson(json);

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
  @JsonKey()
  final String language;
// 응답 언어
  @override
  @JsonKey()
  final int durationDays;

  @override
  String toString() {
    return 'AIRoutineRequest(name: $name, age: $age, job: $job, hobbies: $hobbies, concept: $concept, additionalInfo: $additionalInfo, language: $language, durationDays: $durationDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIRoutineRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.job, job) || other.job == job) &&
            const DeepCollectionEquality().equals(other._hobbies, _hobbies) &&
            (identical(other.concept, concept) || other.concept == concept) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.durationDays, durationDays) ||
                other.durationDays == durationDays));
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
      language,
      durationDays);

  /// Create a copy of AIRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIRoutineRequestImplCopyWith<_$AIRoutineRequestImpl> get copyWith =>
      __$$AIRoutineRequestImplCopyWithImpl<_$AIRoutineRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIRoutineRequestImplToJson(
      this,
    );
  }
}

abstract class _AIRoutineRequest implements AIRoutineRequest {
  const factory _AIRoutineRequest(
      {required final String name,
      required final int age,
      required final String job,
      required final List<String> hobbies,
      required final RoutineConcept concept,
      final String additionalInfo,
      final String language,
      final int durationDays}) = _$AIRoutineRequestImpl;

  factory _AIRoutineRequest.fromJson(Map<String, dynamic> json) =
      _$AIRoutineRequestImpl.fromJson;

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
  String get language; // 응답 언어
  @override
  int get durationDays;

  /// Create a copy of AIRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIRoutineRequestImplCopyWith<_$AIRoutineRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
