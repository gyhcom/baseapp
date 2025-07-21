import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_auth.freezed.dart';
part 'user_auth.g.dart';

@freezed
@HiveType(typeId: 8)
class UserAuth with _$UserAuth {
  const factory UserAuth({
    @HiveField(0) required String uid,
    @HiveField(1) required String email,
    @HiveField(2) required String displayName,
    @HiveField(3) String? photoURL,
    @HiveField(4) required UserAuthProvider provider,
    @HiveField(5) @Default(false) bool isAnonymous,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) DateTime? lastSignInAt,
  }) = _UserAuth;

  factory UserAuth.fromJson(Map<String, dynamic> json) => _$UserAuthFromJson(json);
}

@HiveType(typeId: 9)
enum UserAuthProvider {
  @HiveField(0)
  google,
  @HiveField(1)
  apple,
  @HiveField(2)
  email,
  @HiveField(3)
  anonymous,
}