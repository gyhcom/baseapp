import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_item.freezed.dart';
part 'routine_item.g.dart';

/// TimeOfDay JSON 변환기
class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay timeOfDay) {
    return {
      'hour': timeOfDay.hour,
      'minute': timeOfDay.minute,
    };
  }
}

enum RoutineCategory {
  morning('아침', '기상 및 아침 활동'),
  work('업무/학습', '일 또는 공부 관련 활동'),
  exercise('운동', '신체 활동 및 건강 관리'),
  hobby('취미', '개인적 관심사 및 여가 활동'),
  social('사회적', '사람들과의 교류 및 소통'),
  selfCare('자기관리', '개인 케어 및 웰빙'),
  evening('저녁', '하루 마무리 및 휴식');

  const RoutineCategory(this.displayName, this.description);

  final String displayName;
  final String description;
}

enum RoutinePriority implements Comparable<RoutinePriority> {
  high('높음'),
  medium('보통'),
  low('낮음');

  const RoutinePriority(this.displayName);
  final String displayName;

  @override
  int compareTo(RoutinePriority other) {
    return index.compareTo(other.index);
  }
}

@freezed
class RoutineItem with _$RoutineItem {
  const factory RoutineItem({
    required String id,
    required String title,
    required String description,
    @TimeOfDayConverter() required TimeOfDay startTime,
    required Duration duration,
    @Default('일반') String category,
    @Default(RoutinePriority.medium) RoutinePriority priority,
    @Default(false) bool isCompleted,
    @Default([]) List<String> tags,
    @Default(true) bool isFlexible, // 시간이 유동적인지
  }) = _RoutineItem;

  factory RoutineItem.fromJson(Map<String, dynamic> json) =>
      _$RoutineItemFromJson(json);
}

extension RoutineItemX on RoutineItem {
  String get durationDisplay {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return minutes > 0 ? '${hours}시간 ${minutes}분' : '${hours}시간';
    }
    return '${minutes}분';
  }

  bool get isShortActivity => duration.inMinutes <= 30;
  bool get isLongActivity => duration.inHours >= 2;
  
  String get timeDisplay {
    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}