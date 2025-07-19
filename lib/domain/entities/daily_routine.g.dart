// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyRoutineImpl _$$DailyRoutineImplFromJson(Map<String, dynamic> json) =>
    _$DailyRoutineImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      concept: $enumDecode(_$RoutineConceptEnumMap, json['concept']),
      items: (json['items'] as List<dynamic>)
          .map((e) => RoutineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedFor:
          UserProfile.fromJson(json['generatedFor'] as Map<String, dynamic>),
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DailyRoutineImplToJson(_$DailyRoutineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'concept': _$RoutineConceptEnumMap[instance.concept]!,
      'items': instance.items,
      'generatedFor': instance.generatedFor,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isFavorite': instance.isFavorite,
      'usageCount': instance.usageCount,
    };

const _$RoutineConceptEnumMap = {
  RoutineConcept.godlife: 'godlife',
  RoutineConcept.diligent: 'diligent',
  RoutineConcept.relaxed: 'relaxed',
  RoutineConcept.restful: 'restful',
  RoutineConcept.creative: 'creative',
  RoutineConcept.minimal: 'minimal',
  RoutineConcept.workLifeBalance: 'workLifeBalance',
  RoutineConcept.lazyButRegular: 'lazyButRegular',
  RoutineConcept.mindfulness: 'mindfulness',
  RoutineConcept.physicalHealth: 'physicalHealth',
  RoutineConcept.mentalRecovery: 'mentalRecovery',
  RoutineConcept.challenge: 'challenge',
};
