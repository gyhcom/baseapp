// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_routine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyRoutine _$DailyRoutineFromJson(Map<String, dynamic> json) {
  return _DailyRoutine.fromJson(json);
}

/// @nodoc
mixin _$DailyRoutine {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  RoutineConcept get concept => throw _privateConstructorUsedError;
  List<RoutineItem> get items => throw _privateConstructorUsedError;
  UserProfile get generatedFor => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;

  /// Serializes this DailyRoutine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyRoutine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyRoutineCopyWith<DailyRoutine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRoutineCopyWith<$Res> {
  factory $DailyRoutineCopyWith(
          DailyRoutine value, $Res Function(DailyRoutine) then) =
      _$DailyRoutineCopyWithImpl<$Res, DailyRoutine>;
  @useResult
  $Res call(
      {String id,
      String title,
      RoutineConcept concept,
      List<RoutineItem> items,
      UserProfile generatedFor,
      String description,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isFavorite,
      int usageCount});

  $UserProfileCopyWith<$Res> get generatedFor;
}

/// @nodoc
class _$DailyRoutineCopyWithImpl<$Res, $Val extends DailyRoutine>
    implements $DailyRoutineCopyWith<$Res> {
  _$DailyRoutineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyRoutine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? concept = null,
    Object? items = null,
    Object? generatedFor = null,
    Object? description = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isFavorite = null,
    Object? usageCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      concept: null == concept
          ? _value.concept
          : concept // ignore: cast_nullable_to_non_nullable
              as RoutineConcept,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<RoutineItem>,
      generatedFor: null == generatedFor
          ? _value.generatedFor
          : generatedFor // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of DailyRoutine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get generatedFor {
    return $UserProfileCopyWith<$Res>(_value.generatedFor, (value) {
      return _then(_value.copyWith(generatedFor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DailyRoutineImplCopyWith<$Res>
    implements $DailyRoutineCopyWith<$Res> {
  factory _$$DailyRoutineImplCopyWith(
          _$DailyRoutineImpl value, $Res Function(_$DailyRoutineImpl) then) =
      __$$DailyRoutineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      RoutineConcept concept,
      List<RoutineItem> items,
      UserProfile generatedFor,
      String description,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool isFavorite,
      int usageCount});

  @override
  $UserProfileCopyWith<$Res> get generatedFor;
}

/// @nodoc
class __$$DailyRoutineImplCopyWithImpl<$Res>
    extends _$DailyRoutineCopyWithImpl<$Res, _$DailyRoutineImpl>
    implements _$$DailyRoutineImplCopyWith<$Res> {
  __$$DailyRoutineImplCopyWithImpl(
      _$DailyRoutineImpl _value, $Res Function(_$DailyRoutineImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyRoutine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? concept = null,
    Object? items = null,
    Object? generatedFor = null,
    Object? description = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isFavorite = null,
    Object? usageCount = null,
  }) {
    return _then(_$DailyRoutineImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      concept: null == concept
          ? _value.concept
          : concept // ignore: cast_nullable_to_non_nullable
              as RoutineConcept,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<RoutineItem>,
      generatedFor: null == generatedFor
          ? _value.generatedFor
          : generatedFor // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRoutineImpl implements _DailyRoutine {
  const _$DailyRoutineImpl(
      {required this.id,
      required this.title,
      required this.concept,
      required final List<RoutineItem> items,
      required this.generatedFor,
      this.description = '',
      this.createdAt,
      this.updatedAt,
      this.isFavorite = false,
      this.usageCount = 0})
      : _items = items;

  factory _$DailyRoutineImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRoutineImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final RoutineConcept concept;
  final List<RoutineItem> _items;
  @override
  List<RoutineItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final UserProfile generatedFor;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final int usageCount;

  @override
  String toString() {
    return 'DailyRoutine(id: $id, title: $title, concept: $concept, items: $items, generatedFor: $generatedFor, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, isFavorite: $isFavorite, usageCount: $usageCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRoutineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.concept, concept) || other.concept == concept) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.generatedFor, generatedFor) ||
                other.generatedFor == generatedFor) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      concept,
      const DeepCollectionEquality().hash(_items),
      generatedFor,
      description,
      createdAt,
      updatedAt,
      isFavorite,
      usageCount);

  /// Create a copy of DailyRoutine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRoutineImplCopyWith<_$DailyRoutineImpl> get copyWith =>
      __$$DailyRoutineImplCopyWithImpl<_$DailyRoutineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRoutineImplToJson(
      this,
    );
  }
}

abstract class _DailyRoutine implements DailyRoutine {
  const factory _DailyRoutine(
      {required final String id,
      required final String title,
      required final RoutineConcept concept,
      required final List<RoutineItem> items,
      required final UserProfile generatedFor,
      final String description,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final bool isFavorite,
      final int usageCount}) = _$DailyRoutineImpl;

  factory _DailyRoutine.fromJson(Map<String, dynamic> json) =
      _$DailyRoutineImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  RoutineConcept get concept;
  @override
  List<RoutineItem> get items;
  @override
  UserProfile get generatedFor;
  @override
  String get description;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isFavorite;
  @override
  int get usageCount;

  /// Create a copy of DailyRoutine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyRoutineImplCopyWith<_$DailyRoutineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
