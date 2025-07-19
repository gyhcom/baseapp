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
      category: $enumDecode(_$RoutineCategoryEnumMap, json['category']),
      estimatedDuration:
          Duration(microseconds: (json['estimatedDuration'] as num).toInt()),
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      requiredConditions: (json['requiredConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      timeOfDay: json['timeOfDay'] as String?,
      isFlexible: json['isFlexible'] as bool?,
    );

Map<String, dynamic> _$$RoutineItemImplToJson(_$RoutineItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$RoutineCategoryEnumMap[instance.category]!,
      'estimatedDuration': instance.estimatedDuration.inMicroseconds,
      'priority': instance.priority,
      'requiredConditions': instance.requiredConditions,
      'tags': instance.tags,
      'timeOfDay': instance.timeOfDay,
      'isFlexible': instance.isFlexible,
    };

const _$RoutineCategoryEnumMap = {
  RoutineCategory.morning: 'morning',
  RoutineCategory.work: 'work',
  RoutineCategory.exercise: 'exercise',
  RoutineCategory.hobby: 'hobby',
  RoutineCategory.social: 'social',
  RoutineCategory.selfCare: 'selfCare',
  RoutineCategory.evening: 'evening',
};
