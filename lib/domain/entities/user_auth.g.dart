// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAuthAdapter extends TypeAdapter<UserAuth> {
  @override
  final int typeId = 8;

  @override
  UserAuth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAuth(
      uid: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String,
      photoURL: fields[3] as String?,
      provider: fields[4] as UserAuthProvider,
      isAnonymous: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      lastSignInAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserAuth obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.photoURL)
      ..writeByte(4)
      ..write(obj.provider)
      ..writeByte(5)
      ..write(obj.isAnonymous)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastSignInAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAuthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAuthProviderAdapter extends TypeAdapter<UserAuthProvider> {
  @override
  final int typeId = 9;

  @override
  UserAuthProvider read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserAuthProvider.google;
      case 1:
        return UserAuthProvider.apple;
      case 2:
        return UserAuthProvider.email;
      case 3:
        return UserAuthProvider.anonymous;
      default:
        return UserAuthProvider.google;
    }
  }

  @override
  void write(BinaryWriter writer, UserAuthProvider obj) {
    switch (obj) {
      case UserAuthProvider.google:
        writer.writeByte(0);
        break;
      case UserAuthProvider.apple:
        writer.writeByte(1);
        break;
      case UserAuthProvider.email:
        writer.writeByte(2);
        break;
      case UserAuthProvider.anonymous:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAuthProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserAuthImpl _$$UserAuthImplFromJson(Map<String, dynamic> json) =>
    _$UserAuthImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      provider: $enumDecode(_$UserAuthProviderEnumMap, json['provider']),
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSignInAt: json['lastSignInAt'] == null
          ? null
          : DateTime.parse(json['lastSignInAt'] as String),
    );

Map<String, dynamic> _$$UserAuthImplToJson(_$UserAuthImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'provider': _$UserAuthProviderEnumMap[instance.provider]!,
      'isAnonymous': instance.isAnonymous,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastSignInAt': instance.lastSignInAt?.toIso8601String(),
    };

const _$UserAuthProviderEnumMap = {
  UserAuthProvider.google: 'google',
  UserAuthProvider.apple: 'apple',
  UserAuthProvider.email: 'email',
  UserAuthProvider.anonymous: 'anonymous',
};
