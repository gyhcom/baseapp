// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_usage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserUsageAdapter extends TypeAdapter<UserUsage> {
  @override
  final int typeId = 4;

  @override
  UserUsage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserUsage(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      dailyGenerations: fields[2] as int,
      monthlyGenerations: fields[3] as int,
      bonusGenerations: fields[4] as int,
      isPremium: fields[5] as bool,
      premiumExpiryDate: fields[6] as DateTime?,
      bonusHistory: (fields[7] as List).cast<BonusEarned>(),
      lastResetDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserUsage obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.dailyGenerations)
      ..writeByte(3)
      ..write(obj.monthlyGenerations)
      ..writeByte(4)
      ..write(obj.bonusGenerations)
      ..writeByte(5)
      ..write(obj.isPremium)
      ..writeByte(6)
      ..write(obj.premiumExpiryDate)
      ..writeByte(7)
      ..write(obj.bonusHistory)
      ..writeByte(8)
      ..write(obj.lastResetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserUsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BonusEarnedAdapter extends TypeAdapter<BonusEarned> {
  @override
  final int typeId = 5;

  @override
  BonusEarned read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BonusEarned(
      id: fields[0] as String,
      type: fields[1] as BonusType,
      amount: fields[2] as int,
      earnedAt: fields[3] as DateTime,
      description: fields[4] as String,
      isUsed: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BonusEarned obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.earnedAt)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BonusEarnedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BonusTypeAdapter extends TypeAdapter<BonusType> {
  @override
  final int typeId = 6;

  @override
  BonusType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BonusType.socialShare;
      case 1:
        return BonusType.friendInvite;
      case 2:
        return BonusType.streakAchievement;
      case 3:
        return BonusType.appReview;
      case 4:
        return BonusType.welcomeBonus;
      case 5:
        return BonusType.specialEvent;
      default:
        return BonusType.socialShare;
    }
  }

  @override
  void write(BinaryWriter writer, BonusType obj) {
    switch (obj) {
      case BonusType.socialShare:
        writer.writeByte(0);
        break;
      case BonusType.friendInvite:
        writer.writeByte(1);
        break;
      case BonusType.streakAchievement:
        writer.writeByte(2);
        break;
      case BonusType.appReview:
        writer.writeByte(3);
        break;
      case BonusType.welcomeBonus:
        writer.writeByte(4);
        break;
      case BonusType.specialEvent:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BonusTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserUsageImpl _$$UserUsageImplFromJson(Map<String, dynamic> json) =>
    _$UserUsageImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      dailyGenerations: (json['dailyGenerations'] as num?)?.toInt() ?? 0,
      monthlyGenerations: (json['monthlyGenerations'] as num?)?.toInt() ?? 0,
      bonusGenerations: (json['bonusGenerations'] as num?)?.toInt() ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
      premiumExpiryDate: json['premiumExpiryDate'] == null
          ? null
          : DateTime.parse(json['premiumExpiryDate'] as String),
      bonusHistory: (json['bonusHistory'] as List<dynamic>?)
              ?.map((e) => BonusEarned.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastResetDate: json['lastResetDate'] == null
          ? null
          : DateTime.parse(json['lastResetDate'] as String),
    );

Map<String, dynamic> _$$UserUsageImplToJson(_$UserUsageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'dailyGenerations': instance.dailyGenerations,
      'monthlyGenerations': instance.monthlyGenerations,
      'bonusGenerations': instance.bonusGenerations,
      'isPremium': instance.isPremium,
      'premiumExpiryDate': instance.premiumExpiryDate?.toIso8601String(),
      'bonusHistory': instance.bonusHistory,
      'lastResetDate': instance.lastResetDate?.toIso8601String(),
    };

_$BonusEarnedImpl _$$BonusEarnedImplFromJson(Map<String, dynamic> json) =>
    _$BonusEarnedImpl(
      id: json['id'] as String,
      type: $enumDecode(_$BonusTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toInt(),
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      description: json['description'] as String? ?? '',
      isUsed: json['isUsed'] as bool? ?? false,
    );

Map<String, dynamic> _$$BonusEarnedImplToJson(_$BonusEarnedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$BonusTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'earnedAt': instance.earnedAt.toIso8601String(),
      'description': instance.description,
      'isUsed': instance.isUsed,
    };

const _$BonusTypeEnumMap = {
  BonusType.socialShare: 'socialShare',
  BonusType.friendInvite: 'friendInvite',
  BonusType.streakAchievement: 'streakAchievement',
  BonusType.appReview: 'appReview',
  BonusType.welcomeBonus: 'welcomeBonus',
  BonusType.specialEvent: 'specialEvent',
};
