import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/daily_routine.dart';
import '../../domain/entities/routine_item.dart';
import '../../domain/entities/routine_concept.dart';
import '../../domain/entities/user_profile.dart';

part 'daily_routine_hive.g.dart';

/// Hive용 DailyRoutine 어댑터
@HiveType(typeId: 0)
class DailyRoutineHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String conceptName; // enum을 String으로 저장

  @HiveField(3)
  final List<RoutineItemHive> items;

  @HiveField(4)
  final UserProfileHive generatedFor;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final bool isFavorite;

  @HiveField(8)
  final int usageCount;

  @HiveField(9, defaultValue: false)
  final bool isActive;

  DailyRoutineHive({
    required this.id,
    required this.title,
    required this.conceptName,
    required this.items,
    required this.generatedFor,
    required this.description,
    this.createdAt,
    required this.isFavorite,
    required this.usageCount,
    this.isActive = false,
  });

  /// DailyRoutine 엔티티로 변환
  DailyRoutine toDailyRoutine() {
    return DailyRoutine(
      id: id,
      title: title,
      concept: _stringToConcept(conceptName),
      items: items.map((item) => item.toRoutineItem()).toList(),
      generatedFor: generatedFor.toUserProfile(),
      description: description,
      createdAt: createdAt,
      isFavorite: isFavorite,
      usageCount: usageCount,
      isActive: isActive,
    );
  }

  /// DailyRoutine 엔티티에서 변환
  factory DailyRoutineHive.fromDailyRoutine(DailyRoutine routine) {
    return DailyRoutineHive(
      id: routine.id,
      title: routine.title,
      conceptName: routine.concept.name,
      items: routine.items
          .map((item) => RoutineItemHive.fromRoutineItem(item))
          .toList(),
      generatedFor: UserProfileHive.fromUserProfile(routine.generatedFor),
      description: routine.description,
      createdAt: routine.createdAt,
      isFavorite: routine.isFavorite,
      isActive: routine.isActive,
      usageCount: routine.usageCount,
    );
  }

  RoutineConcept _stringToConcept(String conceptName) {
    return RoutineConcept.values.firstWhere(
      (concept) => concept.name == conceptName,
      orElse: () => RoutineConcept.workLifeBalance,
    );
  }
}

/// Hive용 RoutineItem 어댑터
@HiveType(typeId: 1)
class RoutineItemHive {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int startTimeHour;

  @HiveField(4)
  final int startTimeMinute;

  @HiveField(5)
  final int durationMinutes;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String priorityName; // enum을 String으로 저장

  @HiveField(8)
  final bool isCompleted;

  RoutineItemHive({
    required this.id,
    required this.title,
    required this.description,
    required this.startTimeHour,
    required this.startTimeMinute,
    required this.durationMinutes,
    required this.category,
    required this.priorityName,
    required this.isCompleted,
  });

  /// RoutineItem 엔티티로 변환
  RoutineItem toRoutineItem() {
    return RoutineItem(
      id: id,
      title: title,
      description: description,
      startTime: TimeOfDay(hour: startTimeHour, minute: startTimeMinute),
      duration: Duration(minutes: durationMinutes),
      category: category,
      priority: _stringToPriority(priorityName),
      isCompleted: isCompleted,
    );
  }

  /// RoutineItem 엔티티에서 변환
  factory RoutineItemHive.fromRoutineItem(RoutineItem item) {
    return RoutineItemHive(
      id: item.id,
      title: item.title,
      description: item.description,
      startTimeHour: item.startTime.hour,
      startTimeMinute: item.startTime.minute,
      durationMinutes: item.duration.inMinutes,
      category: item.category,
      priorityName: item.priority.name,
      isCompleted: item.isCompleted,
    );
  }

  RoutinePriority _stringToPriority(String priorityName) {
    return RoutinePriority.values.firstWhere(
      (priority) => priority.name == priorityName,
      orElse: () => RoutinePriority.medium,
    );
  }
}

/// Hive용 UserProfile 어댑터
@HiveType(typeId: 2)
class UserProfileHive {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final String job;

  @HiveField(3)
  final List<String> hobbies;

  @HiveField(4)
  final String conceptName;

  @HiveField(5)
  final String additionalInfo;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  UserProfileHive({
    required this.name,
    required this.age,
    required this.job,
    required this.hobbies,
    required this.conceptName,
    required this.additionalInfo,
    this.createdAt,
    this.updatedAt,
  });

  /// UserProfile 엔티티로 변환
  UserProfile toUserProfile() {
    return UserProfile(
      name: name,
      age: age,
      job: job,
      hobbies: hobbies,
      concept: _stringToConcept(conceptName),
      additionalInfo: additionalInfo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// UserProfile 엔티티에서 변환
  factory UserProfileHive.fromUserProfile(UserProfile profile) {
    return UserProfileHive(
      name: profile.name,
      age: profile.age,
      job: profile.job,
      hobbies: profile.hobbies,
      conceptName: profile.concept.name,
      additionalInfo: profile.additionalInfo,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  RoutineConcept _stringToConcept(String conceptName) {
    return RoutineConcept.values.firstWhere(
      (concept) => concept.name == conceptName,
      orElse: () => RoutineConcept.workLifeBalance,
    );
  }
}
