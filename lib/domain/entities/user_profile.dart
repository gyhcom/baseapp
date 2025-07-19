import 'package:freezed_annotation/freezed_annotation.dart';
import 'routine_concept.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String name,
    required int age,
    required String job,
    required List<String> hobbies,
    required RoutineConcept concept,
    @Default('') String additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileX on UserProfile {
  bool get isValid =>
      name.isNotEmpty &&
      age > 0 &&
      age < 150 &&
      job.isNotEmpty &&
      hobbies.isNotEmpty;

  String get ageGroup {
    if (age < 20) return '10대';
    if (age < 30) return '20대';
    if (age < 40) return '30대';
    if (age < 50) return '40대';
    if (age < 60) return '50대';
    return '60대 이상';
  }

  String get hobbiesDisplay => hobbies.join(', ');
}