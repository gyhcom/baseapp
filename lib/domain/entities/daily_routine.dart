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
      (total, item) => total + item.estimatedDuration,
    );
  }

  List<RoutineItem> get morningItems {
    return items.where((item) => 
      item.category == RoutineCategory.morning ||
      (item.timeOfDay != null && 
       int.parse(item.timeOfDay!.split(':')[0]) < 12)
    ).toList();
  }

  List<RoutineItem> get afternoonItems {
    return items.where((item) => 
      item.category == RoutineCategory.work ||
      (item.timeOfDay != null && 
       int.parse(item.timeOfDay!.split(':')[0]) >= 12 &&
       int.parse(item.timeOfDay!.split(':')[0]) < 18)
    ).toList();
  }

  List<RoutineItem> get eveningItems {
    return items.where((item) => 
      item.category == RoutineCategory.evening ||
      (item.timeOfDay != null && 
       int.parse(item.timeOfDay!.split(':')[0]) >= 18)
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

  Map<RoutineCategory, List<RoutineItem>> get itemsByCategory {
    final Map<RoutineCategory, List<RoutineItem>> categorized = {};
    
    for (final category in RoutineCategory.values) {
      categorized[category] = items
          .where((item) => item.category == category)
          .toList();
    }
    
    return categorized;
  }
}