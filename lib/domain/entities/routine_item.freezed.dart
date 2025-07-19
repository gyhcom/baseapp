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
  RoutineCategory get category => throw _privateConstructorUsedError;
  Duration get estimatedDuration => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError; // 1-5 (1이 가장 높음)
  List<String> get requiredConditions => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get timeOfDay =>
      throw _privateConstructorUsedError; // '06:00', '07:30' 등
  bool? get isFlexible => throw _privateConstructorUsedError;

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
      RoutineCategory category,
      Duration estimatedDuration,
      int priority,
      List<String> requiredConditions,
      List<String> tags,
      String? timeOfDay,
      bool? isFlexible});
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
    Object? category = null,
    Object? estimatedDuration = null,
    Object? priority = null,
    Object? requiredConditions = null,
    Object? tags = null,
    Object? timeOfDay = freezed,
    Object? isFlexible = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as RoutineCategory,
      estimatedDuration: null == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      requiredConditions: null == requiredConditions
          ? _value.requiredConditions
          : requiredConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeOfDay: freezed == timeOfDay
          ? _value.timeOfDay
          : timeOfDay // ignore: cast_nullable_to_non_nullable
              as String?,
      isFlexible: freezed == isFlexible
          ? _value.isFlexible
          : isFlexible // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      RoutineCategory category,
      Duration estimatedDuration,
      int priority,
      List<String> requiredConditions,
      List<String> tags,
      String? timeOfDay,
      bool? isFlexible});
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
    Object? category = null,
    Object? estimatedDuration = null,
    Object? priority = null,
    Object? requiredConditions = null,
    Object? tags = null,
    Object? timeOfDay = freezed,
    Object? isFlexible = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as RoutineCategory,
      estimatedDuration: null == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      requiredConditions: null == requiredConditions
          ? _value._requiredConditions
          : requiredConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeOfDay: freezed == timeOfDay
          ? _value.timeOfDay
          : timeOfDay // ignore: cast_nullable_to_non_nullable
              as String?,
      isFlexible: freezed == isFlexible
          ? _value.isFlexible
          : isFlexible // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      required this.category,
      required this.estimatedDuration,
      this.priority = 1,
      final List<String> requiredConditions = const [],
      final List<String> tags = const [],
      this.timeOfDay,
      this.isFlexible})
      : _requiredConditions = requiredConditions,
        _tags = tags;

  factory _$RoutineItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final RoutineCategory category;
  @override
  final Duration estimatedDuration;
  @override
  @JsonKey()
  final int priority;
// 1-5 (1이 가장 높음)
  final List<String> _requiredConditions;
// 1-5 (1이 가장 높음)
  @override
  @JsonKey()
  List<String> get requiredConditions {
    if (_requiredConditions is EqualUnmodifiableListView)
      return _requiredConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredConditions);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? timeOfDay;
// '06:00', '07:30' 등
  @override
  final bool? isFlexible;

  @override
  String toString() {
    return 'RoutineItem(id: $id, title: $title, description: $description, category: $category, estimatedDuration: $estimatedDuration, priority: $priority, requiredConditions: $requiredConditions, tags: $tags, timeOfDay: $timeOfDay, isFlexible: $isFlexible)';
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
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality()
                .equals(other._requiredConditions, _requiredConditions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
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
      category,
      estimatedDuration,
      priority,
      const DeepCollectionEquality().hash(_requiredConditions),
      const DeepCollectionEquality().hash(_tags),
      timeOfDay,
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
      required final RoutineCategory category,
      required final Duration estimatedDuration,
      final int priority,
      final List<String> requiredConditions,
      final List<String> tags,
      final String? timeOfDay,
      final bool? isFlexible}) = _$RoutineItemImpl;

  factory _RoutineItem.fromJson(Map<String, dynamic> json) =
      _$RoutineItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  RoutineCategory get category;
  @override
  Duration get estimatedDuration;
  @override
  int get priority; // 1-5 (1이 가장 높음)
  @override
  List<String> get requiredConditions;
  @override
  List<String> get tags;
  @override
  String? get timeOfDay; // '06:00', '07:30' 등
  @override
  bool? get isFlexible;

  /// Create a copy of RoutineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineItemImplCopyWith<_$RoutineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
