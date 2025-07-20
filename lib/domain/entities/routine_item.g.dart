// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoutineItemImpl _$$RoutineItemImplFromJson(Map<String, dynamic> json) =>
    _$RoutineItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: const TimeOfDayConverter()
          .fromJson(json['startTime'] as Map<String, dynamic>),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      category: json['category'] as String? ?? '일반',
      priority:
          $enumDecodeNullable(_$RoutinePriorityEnumMap, json['priority']) ??
              RoutinePriority.medium,
      isCompleted: json['isCompleted'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isFlexible: json['isFlexible'] as bool? ?? true,
    );

Map<String, dynamic> _$$RoutineItemImplToJson(_$RoutineItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startTime': const TimeOfDayConverter().toJson(instance.startTime),
      'duration': instance.duration.inMicroseconds,
      'category': instance.category,
      'priority': _$RoutinePriorityEnumMap[instance.priority]!,
      'isCompleted': instance.isCompleted,
      'tags': instance.tags,
      'isFlexible': instance.isFlexible,
    };

const _$RoutinePriorityEnumMap = {
  RoutinePriority.high: 'high',
  RoutinePriority.medium: 'medium',
  RoutinePriority.low: 'low',
};
