import '../entities/ai_routine_request.dart';
import '../entities/ai_routine_response.dart';
import '../repositories/ai_service_repository.dart';

/// AI 루틴 생성 UseCase
class AIRoutineUsecase {
  final AIServiceRepository _aiService;

  AIRoutineUsecase(this._aiService);

  /// 루틴 생성 요청
  Future<AIRoutineResponse> generateRoutine(AIRoutineRequest request) async {
    try {
      // 입력 검증
      if (!_validateRequest(request)) {
        return AIRoutineResponse.failure(
          error: '입력 정보가 올바르지 않습니다',
          message: '모든 필수 정보를 입력해주세요',
        );
      }

      // AI 서비스 상태 확인
      if (!_aiService.isConfigured) {
        return AIRoutineResponse.failure(
          error: 'AI 서비스가 설정되지 않았습니다',
          message: 'AI 서비스 설정을 확인해주세요',
        );
      }

      // 루틴 생성 요청
      final response = await _aiService.generateRoutine(request);
      
      return response;
    } catch (e) {
      return AIRoutineResponse.failure(
        error: e.toString(),
        message: '예상치 못한 오류가 발생했습니다',
      );
    }
  }

  /// AI 서비스 상태 확인
  Future<bool> checkServiceHealth() async {
    try {
      return await _aiService.checkServiceHealth();
    } catch (e) {
      return false;
    }
  }

  /// 사용 가능한 AI 서비스 정보
  String get serviceName => _aiService.serviceName;
  
  List<String> get supportedLanguages => _aiService.supportedLanguages;

  /// 요청 데이터 검증
  bool _validateRequest(AIRoutineRequest request) {
    // 필수 필드 검증
    if (request.name.trim().isEmpty) return false;
    if (request.age <= 0 || request.age > 150) return false;
    if (request.job.trim().isEmpty) return false;
    if (request.hobbies.isEmpty) return false;
    
    // 취미 개수 제한 (너무 많으면 프롬프트가 길어짐)
    if (request.hobbies.length > 10) return false;
    
    // 추가 정보 길이 제한
    if (request.additionalInfo.length > 500) return false;
    
    return true;
  }

  /// 요청 데이터 정리 (선택사항)
  AIRoutineRequest sanitizeRequest(AIRoutineRequest request) {
    return request.copyWith(
      name: request.name.trim(),
      job: request.job.trim(),
      hobbies: request.hobbies
          .map((hobby) => hobby.trim())
          .where((hobby) => hobby.isNotEmpty)
          .toList(),
      additionalInfo: request.additionalInfo.trim(),
    );
  }
}