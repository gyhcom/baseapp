// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_routine_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIRoutineRequestImpl _$$AIRoutineRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AIRoutineRequestImpl(
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      job: json['job'] as String,
      hobbies:
          (json['hobbies'] as List<dynamic>).map((e) => e as String).toList(),
      concept: $enumDecode(_$RoutineConceptEnumMap, json['concept']),
      additionalInfo: json['additionalInfo'] as String? ?? '',
      language: json['language'] as String? ?? 'ko',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 7,
    );

Map<String, dynamic> _$$AIRoutineRequestImplToJson(
        _$AIRoutineRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'job': instance.job,
      'hobbies': instance.hobbies,
      'concept': _$RoutineConceptEnumMap[instance.concept]!,
      'additionalInfo': instance.additionalInfo,
      'language': instance.language,
      'durationDays': instance.durationDays,
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
