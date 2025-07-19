// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      job: json['job'] as String,
      hobbies:
          (json['hobbies'] as List<dynamic>).map((e) => e as String).toList(),
      concept: $enumDecode(_$RoutineConceptEnumMap, json['concept']),
      additionalInfo: json['additionalInfo'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'job': instance.job,
      'hobbies': instance.hobbies,
      'concept': _$RoutineConceptEnumMap[instance.concept]!,
      'additionalInfo': instance.additionalInfo,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
