import 'package:freezed_annotation/freezed_annotation.dart';
import 'daily_routine.dart';

part 'ai_routine_response.freezed.dart';
part 'ai_routine_response.g.dart';

/// AI로부터 받은 루틴 생성 응답
@freezed
class AIRoutineResponse with _$AIRoutineResponse {
  const factory AIRoutineResponse({
    required bool success,
    required String message,
    DailyRoutine? routine,
    String? error,
    @Default(0) int tokensUsed,
    DateTime? generatedAt,
  }) = _AIRoutineResponse;

  factory AIRoutineResponse.fromJson(Map<String, dynamic> json) =>
      _$AIRoutineResponseFromJson(json);
  
  /// 성공 응답 생성
  factory AIRoutineResponse.success({
    required DailyRoutine routine,
    String message = '루틴이 성공적으로 생성되었습니다',
    int tokensUsed = 0,
  }) {
    return AIRoutineResponse(
      success: true,
      message: message,
      routine: routine,
      tokensUsed: tokensUsed,
      generatedAt: DateTime.now(),
    );
  }
  
  /// 실패 응답 생성
  factory AIRoutineResponse.failure({
    required String error,
    String message = '루틴 생성에 실패했습니다',
  }) {
    return AIRoutineResponse(
      success: false,
      message: message,
      error: error,
      generatedAt: DateTime.now(),
    );
  }
}

extension AIRoutineResponseX on AIRoutineResponse {
  /// 에러가 있는지 확인
  bool get hasError => error != null;
  
  /// 루틴이 있는지 확인
  bool get hasRoutine => routine != null;
  
  /// 사용자에게 보여줄 메시지
  String get displayMessage {
    if (success && routine != null) {
      return '${routine!.generatedFor.name}님의 ${routine!.concept.displayName} 루틴이 완성되었어요! ✨';
    }
    return message;
  }
}