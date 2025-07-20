// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoutineItem _$RoutineItemFromJson(Map<String, dynamic> json) {
  return _RoutineItem.fromJson(json);
}

/// @nodoc
mixin _$RoutineItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get startTime => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  RoutinePriority get priority => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isFlexible => throw _privateConstructorUsedError;

  /// Serializes this RoutineItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineItemCopyWith<RoutineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineItemCopyWith<$Res> {
  factory $RoutineItemCopyWith(
          RoutineItem value, $Res Function(RoutineItem) then) =
      _$RoutineItemCopyWithImpl<$Res, RoutineItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @TimeOfDayConverter() TimeOfDay startTime,
      Duration duration,
      String category,
      RoutinePriority priority,
      bool isCompleted,
      List<String> tags,
      bool isFlexible});
}

/// @nodoc
class _$RoutineItemCopyWithImpl<$Res, $Val extends RoutineItem>
    implements $RoutineItemCopyWith<$Res> {
  _$RoutineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? duration = null,
    Object? category = null,
    Object? priority = null,
    Object? isCompleted = null,
    Object? tags = null,
    Object? isFlexible = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as RoutinePriority,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFlexible: null == isFlexible
          ? _value.isFlexible
          : isFlexible // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineItemImplCopyWith<$Res>
    implements $RoutineItemCopyWith<$Res> {
  factory _$$RoutineItemImplCopyWith(
          _$RoutineItemImpl value, $Res Function(_$RoutineItemImpl) then) =
      __$$RoutineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @TimeOfDayConverter() TimeOfDay startTime,
      Duration duration,
      String category,
      RoutinePriority priority,
      bool isCompleted,
      List<String> tags,
      bool isFlexible});
}

/// @nodoc
class __$$RoutineItemImplCopyWithImpl<$Res>
    extends _$RoutineItemCopyWithImpl<$Res, _$RoutineItemImpl>
    implements _$$RoutineItemImplCopyWith<$Res> {
  __$$RoutineItemImplCopyWithImpl(
      _$RoutineItemImpl _value, $Res Function(_$RoutineItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoutineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? duration = null,
    Object? category = null,
    Object? priority = null,
    Object? isCompleted = null,
    Object? tags = null,
    Object? isFlexible = null,
  }) {
    return _then(_$RoutineItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as RoutinePriority,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFlexible: null == isFlexible
          ? _value.isFlexible
          : isFlexible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineItemImpl implements _RoutineItem {
  const _$RoutineItemImpl(
      {required this.id,
      required this.title,
      required this.description,
      @TimeOfDayConverter() required this.startTime,
      required this.duration,
      this.category = '일반',
      this.priority = RoutinePriority.medium,
      this.isCompleted = false,
      final List<String> tags = const [],
      this.isFlexible = true})
      : _tags = tags;

  factory _$RoutineItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @TimeOfDayConverter()
  final TimeOfDay startTime;
  @override
  final Duration duration;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final RoutinePriority priority;
  @override
  @JsonKey()
  final bool isCompleted;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isFlexible;

  @override
  String toString() {
    return 'RoutineItem(id: $id, title: $title, description: $description, startTime: $startTime, duration: $duration, category: $category, priority: $priority, isCompleted: $isCompleted, tags: $tags, isFlexible: $isFlexible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isFlexible, isFlexible) ||
                other.isFlexible == isFlexible));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      startTime,
      duration,
      category,
      priority,
      isCompleted,
      const DeepCollectionEquality().hash(_tags),
      isFlexible);

  /// Create a copy of RoutineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineItemImplCopyWith<_$RoutineItemImpl> get copyWith =>
      __$$RoutineItemImplCopyWithImpl<_$RoutineItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineItemImplToJson(
      this,
    );
  }
}

abstract class _RoutineItem implements RoutineItem {
  const factory _RoutineItem(
      {required final String id,
      required final String title,
      required final String description,
      @TimeOfDayConverter() required final TimeOfDay startTime,
      required final Duration duration,
      final String category,
      final RoutinePriority priority,
      final bool isCompleted,
      final List<String> tags,
      final bool isFlexible}) = _$RoutineItemImpl;

  factory _RoutineItem.fromJson(Map<String, dynamic> json) =
      _$RoutineItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @TimeOfDayConverter()
  TimeOfDay get startTime;
  @override
  Duration get duration;
  @override
  String get category;
  @override
  RoutinePriority get priority;
  @override
  bool get isCompleted;
  @override
  List<String> get tags;
  @override
  bool get isFlexible;

  /// Create a copy of RoutineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineItemImplCopyWith<_$RoutineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
