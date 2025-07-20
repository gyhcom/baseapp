import 'package:freezed_annotation/freezed_annotation.dart';
import 'routine_item.dart';
import 'routine_concept.dart';
import 'user_profile.dart';

part 'daily_routine.freezed.dart';
part 'daily_routine.g.dart';

@freezed
class DailyRoutine with _$DailyRoutine {
  const factory DailyRoutine({
    required String id,
    required String title,
    required RoutineConcept concept,
    required List<RoutineItem> items,
    required UserProfile generatedFor,
    @Default('') String description,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isFavorite,
    @Default(0) int usageCount,
  }) = _DailyRoutine;

  factory DailyRoutine.fromJson(Map<String, dynamic> json) =>
      _$DailyRoutineFromJson(json);
}

extension DailyRoutineX on DailyRoutine {
  Duration get totalDuration {
    return items.fold(
      Duration.zero,
      (total, item) => total + item.duration,
    );
  }

  List<RoutineItem> get morningItems {
    return items.where((item) => 
      item.category.contains('아침') ||
      item.startTime.hour < 12
    ).toList();
  }

  List<RoutineItem> get afternoonItems {
    return items.where((item) => 
      item.category.contains('업무') || item.category.contains('오후') ||
      (item.startTime.hour >= 12 && item.startTime.hour < 18)
    ).toList();
  }

  List<RoutineItem> get eveningItems {
    return items.where((item) => 
      item.category.contains('저녁') ||
      item.startTime.hour >= 18
    ).toList();
  }

  String get totalDurationDisplay {
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes % 60;
    
    if (hours > 0) {
      return minutes > 0 ? '${hours}시간 ${minutes}분' : '${hours}시간';
    }
    return '${minutes}분';
  }

  Map<String, List<RoutineItem>> get itemsByCategory {
    final Map<String, List<RoutineItem>> categorized = {};
    
    // 카테고리별로 루틴 아이템들을 그룹화
    for (final item in items) {
      if (categorized[item.category] == null) {
        categorized[item.category] = [];
      }
      categorized[item.category]!.add(item);
    }
    
    return categorized;
  }
}