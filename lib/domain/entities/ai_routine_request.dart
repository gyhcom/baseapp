import 'package:freezed_annotation/freezed_annotation.dart';
import 'routine_concept.dart';
import 'user_profile.dart';

part 'ai_routine_request.freezed.dart';
part 'ai_routine_request.g.dart';

/// AI에게 루틴 생성을 요청할 때 사용하는 모델
@freezed
class AIRoutineRequest with _$AIRoutineRequest {
  const factory AIRoutineRequest({
    required String name,
    required int age,
    required String job,
    required List<String> hobbies,
    required RoutineConcept concept,
    @Default('') String additionalInfo,
    @Default('ko') String language, // 응답 언어
    @Default(7) int durationDays, // 루틴 기간 (기본 7일)
  }) = _AIRoutineRequest;

  factory AIRoutineRequest.fromJson(Map<String, dynamic> json) =>
      _$AIRoutineRequestFromJson(json);
}

extension AIRoutineRequestX on AIRoutineRequest {
  /// AI 프롬프트용 사용자 정보 요약
  String get userSummary {
    final hobbyText = hobbies.join(', ');
    return '$age세 $job, 취미: $hobbyText, 컨셉: ${concept.displayName}';
  }

  /// 취미를 문자열로 변환
  String get hobbiesText => hobbies.join(', ');
  
  /// 연령대 계산
  String get ageGroup {
    if (age < 20) return '10대';
    if (age < 30) return '20대';
    if (age < 40) return '30대';
    if (age < 50) return '40대';
    if (age < 60) return '50대';
    return '60대 이상';
  }
}

extension AIRoutineRequestToUserProfile on AIRoutineRequest {
  UserProfile toUserProfile() {
    return UserProfile(
      name: name,
      age: age,
      job: job,
      hobbies: hobbies,
      concept: concept,
      additionalInfo: additionalInfo,
      createdAt: DateTime.now(),
    );
  }
}