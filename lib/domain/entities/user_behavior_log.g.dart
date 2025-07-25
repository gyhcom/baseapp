// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_behavior_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserBehaviorLogImpl _$$UserBehaviorLogImplFromJson(
        Map<String, dynamic> json) =>
    _$UserBehaviorLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      routineId: json['routineId'] as String,
      routineItemId: json['routineItemId'] as String,
      behaviorType: $enumDecode(_$BehaviorTypeEnumMap, json['behaviorType']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      hourOfDay: (json['hourOfDay'] as num).toInt(),
      weather: json['weather'] as String?,
      location: json['location'] as String?,
      notificationSentAt: json['notificationSentAt'] == null
          ? null
          : DateTime.parse(json['notificationSentAt'] as String),
      responseDelay: json['responseDelay'] == null
          ? null
          : Duration(microseconds: (json['responseDelay'] as num).toInt()),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserBehaviorLogImplToJson(
        _$UserBehaviorLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'routineId': instance.routineId,
      'routineItemId': instance.routineItemId,
      'behaviorType': _$BehaviorTypeEnumMap[instance.behaviorType]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'dayOfWeek': instance.dayOfWeek,
      'hourOfDay': instance.hourOfDay,
      'weather': instance.weather,
      'location': instance.location,
      'notificationSentAt': instance.notificationSentAt?.toIso8601String(),
      'responseDelay': instance.responseDelay?.inMicroseconds,
      'metadata': instance.metadata,
      'isSynced': instance.isSynced,
    };

const _$BehaviorTypeEnumMap = {
  BehaviorType.routineStarted: 'routine_started',
  BehaviorType.routineCompleted: 'routine_completed',
  BehaviorType.routineSkipped: 'routine_skipped',
  BehaviorType.routineDelayed: 'routine_delayed',
  BehaviorType.notificationDismissed: 'notification_dismissed',
  BehaviorType.notificationResponded: 'notification_responded',
  BehaviorType.appOpened: 'app_opened',
  BehaviorType.routineViewed: 'routine_viewed',
};

_$BehaviorPatternImpl _$$BehaviorPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$BehaviorPatternImpl(
      userId: json['userId'] as String,
      routineId: json['routineId'] as String,
      hourlySuccessRate:
          (json['hourlySuccessRate'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
      ),
      weeklySuccessRate:
          (json['weeklySuccessRate'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
      ),
      averageResponseTime:
          Duration(microseconds: (json['averageResponseTime'] as num).toInt()),
      notificationEffectiveness:
          (json['notificationEffectiveness'] as num).toDouble(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      overallSuccessRate: (json['overallSuccessRate'] as num).toDouble(),
      suggestedTimes: (json['suggestedTimes'] as List<dynamic>)
          .map((e) => OptimalTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      totalDataPoints: (json['totalDataPoints'] as num).toInt(),
    );

Map<String, dynamic> _$$BehaviorPatternImplToJson(
        _$BehaviorPatternImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'routineId': instance.routineId,
      'hourlySuccessRate':
          instance.hourlySuccessRate.map((k, e) => MapEntry(k.toString(), e)),
      'weeklySuccessRate':
          instance.weeklySuccessRate.map((k, e) => MapEntry(k.toString(), e)),
      'averageResponseTime': instance.averageResponseTime.inMicroseconds,
      'notificationEffectiveness': instance.notificationEffectiveness,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'overallSuccessRate': instance.overallSuccessRate,
      'suggestedTimes': instance.suggestedTimes,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'totalDataPoints': instance.totalDataPoints,
    };

_$OptimalTimeImpl _$$OptimalTimeImplFromJson(Map<String, dynamic> json) =>
    _$OptimalTimeImpl(
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      hour: (json['hour'] as num).toInt(),
      successProbability: (json['successProbability'] as num).toDouble(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$OptimalTimeImplToJson(_$OptimalTimeImpl instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'hour': instance.hour,
      'successProbability': instance.successProbability,
      'reason': instance.reason,
    };
