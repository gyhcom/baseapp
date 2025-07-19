// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_routine_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIRoutineResponseImpl _$$AIRoutineResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AIRoutineResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      routine: json['routine'] == null
          ? null
          : DailyRoutine.fromJson(json['routine'] as Map<String, dynamic>),
      error: json['error'] as String?,
      tokensUsed: (json['tokensUsed'] as num?)?.toInt() ?? 0,
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$AIRoutineResponseImplToJson(
        _$AIRoutineResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'routine': instance.routine,
      'error': instance.error,
      'tokensUsed': instance.tokensUsed,
      'generatedAt': instance.generatedAt?.toIso8601String(),
    };
