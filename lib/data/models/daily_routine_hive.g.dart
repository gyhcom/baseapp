// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_routine_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyRoutineHiveAdapter extends TypeAdapter<DailyRoutineHive> {
  @override
  final int typeId = 0;

  @override
  DailyRoutineHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();

    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyRoutineHive(
      id: fields[0] as String,
      title: fields[1] as String,
      conceptName: fields[2] as String,
      items: (fields[3] as List).cast<RoutineItemHive>(),
      generatedFor: fields[4] as UserProfileHive,
      description: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      isFavorite: fields[7] as bool,
      usageCount: fields[8] as int,
      isActive: fields[9] == null ? false : fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyRoutineHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.conceptName)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.generatedFor)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isFavorite)
      ..writeByte(8)
      ..write(obj.usageCount)
      ..writeByte(9)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyRoutineHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoutineItemHiveAdapter extends TypeAdapter<RoutineItemHive> {
  @override
  final int typeId = 1;

  @override
  RoutineItemHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutineItemHive(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      startTimeHour: fields[3] as int,
      startTimeMinute: fields[4] as int,
      durationMinutes: fields[5] as int,
      category: fields[6] as String,
      priorityName: fields[7] as String,
      isCompleted: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RoutineItemHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startTimeHour)
      ..writeByte(4)
      ..write(obj.startTimeMinute)
      ..writeByte(5)
      ..write(obj.durationMinutes)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.priorityName)
      ..writeByte(8)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineItemHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfileHiveAdapter extends TypeAdapter<UserProfileHive> {
  @override
  final int typeId = 2;

  @override
  UserProfileHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileHive(
      name: fields[0] as String,
      age: fields[1] as int,
      job: fields[2] as String,
      hobbies: (fields[3] as List).cast<String>(),
      conceptName: fields[4] as String,
      additionalInfo: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.job)
      ..writeByte(3)
      ..write(obj.hobbies)
      ..writeByte(4)
      ..write(obj.conceptName)
      ..writeByte(5)
      ..write(obj.additionalInfo)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
