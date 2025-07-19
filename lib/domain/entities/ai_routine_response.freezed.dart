// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_routine_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIRoutineResponse _$AIRoutineResponseFromJson(Map<String, dynamic> json) {
  return _AIRoutineResponse.fromJson(json);
}

/// @nodoc
mixin _$AIRoutineResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DailyRoutine? get routine => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get tokensUsed => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this AIRoutineResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIRoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIRoutineResponseCopyWith<AIRoutineResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIRoutineResponseCopyWith<$Res> {
  factory $AIRoutineResponseCopyWith(
          AIRoutineResponse value, $Res Function(AIRoutineResponse) then) =
      _$AIRoutineResponseCopyWithImpl<$Res, AIRoutineResponse>;
  @useResult
  $Res call(
      {bool success,
      String message,
      DailyRoutine? routine,
      String? error,
      int tokensUsed,
      DateTime? generatedAt});

  $DailyRoutineCopyWith<$Res>? get routine;
}

/// @nodoc
class _$AIRoutineResponseCopyWithImpl<$Res, $Val extends AIRoutineResponse>
    implements $AIRoutineResponseCopyWith<$Res> {
  _$AIRoutineResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIRoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? routine = freezed,
    Object? error = freezed,
    Object? tokensUsed = null,
    Object? generatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      routine: freezed == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as DailyRoutine?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      tokensUsed: null == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of AIRoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyRoutineCopyWith<$Res>? get routine {
    if (_value.routine == null) {
      return null;
    }

    return $DailyRoutineCopyWith<$Res>(_value.routine!, (value) {
      return _then(_value.copyWith(routine: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AIRoutineResponseImplCopyWith<$Res>
    implements $AIRoutineResponseCopyWith<$Res> {
  factory _$$AIRoutineResponseImplCopyWith(_$AIRoutineResponseImpl value,
          $Res Function(_$AIRoutineResponseImpl) then) =
      __$$AIRoutineResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String message,
      DailyRoutine? routine,
      String? error,
      int tokensUsed,
      DateTime? generatedAt});

  @override
  $DailyRoutineCopyWith<$Res>? get routine;
}

/// @nodoc
class __$$AIRoutineResponseImplCopyWithImpl<$Res>
    extends _$AIRoutineResponseCopyWithImpl<$Res, _$AIRoutineResponseImpl>
    implements _$$AIRoutineResponseImplCopyWith<$Res> {
  __$$AIRoutineResponseImplCopyWithImpl(_$AIRoutineResponseImpl _value,
      $Res Function(_$AIRoutineResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIRoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? routine = freezed,
    Object? error = freezed,
    Object? tokensUsed = null,
    Object? generatedAt = freezed,
  }) {
    return _then(_$AIRoutineResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      routine: freezed == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as DailyRoutine?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      tokensUsed: null == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIRoutineResponseImpl implements _AIRoutineResponse {
  const _$AIRoutineResponseImpl(
      {required this.success,
      required this.message,
      this.routine,
      this.error,
      this.tokensUsed = 0,
      this.generatedAt});

  factory _$AIRoutineResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIRoutineResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final DailyRoutine? routine;
  @override
  final String? error;
  @override
  @JsonKey()
  final int tokensUsed;
  @override
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'AIRoutineResponse(success: $success, message: $message, routine: $routine, error: $error, tokensUsed: $tokensUsed, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIRoutineResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.routine, routine) || other.routine == routine) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.tokensUsed, tokensUsed) ||
                other.tokensUsed == tokensUsed) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, success, message, routine, error, tokensUsed, generatedAt);

  /// Create a copy of AIRoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIRoutineResponseImplCopyWith<_$AIRoutineResponseImpl> get copyWith =>
      __$$AIRoutineResponseImplCopyWithImpl<_$AIRoutineResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIRoutineResponseImplToJson(
      this,
    );
  }
}

abstract class _AIRoutineResponse implements AIRoutineResponse {
  const factory _AIRoutineResponse(
      {required final bool success,
      required final String message,
      final DailyRoutine? routine,
      final String? error,
      final int tokensUsed,
      final DateTime? generatedAt}) = _$AIRoutineResponseImpl;

  factory _AIRoutineResponse.fromJson(Map<String, dynamic> json) =
      _$AIRoutineResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  DailyRoutine? get routine;
  @override
  String? get error;
  @override
  int get tokensUsed;
  @override
  DateTime? get generatedAt;

  /// Create a copy of AIRoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIRoutineResponseImplCopyWith<_$AIRoutineResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
