import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_item.freezed.dart';
part 'routine_item.g.dart';

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

@freezed
class RoutineItem with _$RoutineItem {
  const factory RoutineItem({
    required String id,
    required String title,
    required String description,
    required RoutineCategory category,
    required Duration estimatedDuration,
    @Default(1) int priority, // 1-5 (1이 가장 높음)
    @Default([]) List<String> requiredConditions,
    @Default([]) List<String> tags,
    String? timeOfDay, // '06:00', '07:30' 등
    bool? isFlexible, // 시간이 유동적인지
  }) = _RoutineItem;

  factory RoutineItem.fromJson(Map<String, dynamic> json) =>
      _$RoutineItemFromJson(json);
}

extension RoutineItemX on RoutineItem {
  String get durationDisplay {
    final hours = estimatedDuration.inHours;
    final minutes = estimatedDuration.inMinutes % 60;
    
    if (hours > 0) {
      return minutes > 0 ? '${hours}시간 ${minutes}분' : '${hours}시간';
    }
    return '${minutes}분';
  }

  bool get isShortActivity => estimatedDuration.inMinutes <= 30;
  bool get isLongActivity => estimatedDuration.inHours >= 2;
}