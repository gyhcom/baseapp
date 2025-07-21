import '../entities/ai_routine_request.dart';
import '../entities/ai_routine_response.dart';

/// AI 서비스 추상 인터페이스
/// 이 인터페이스를 구현하여 다양한 AI 서비스를 사용할 수 있음
abstract class AIServiceRepository {
  /// 루틴 생성 요청
  Future<AIRoutineResponse> generateRoutine(AIRoutineRequest request);
  
  /// AI 서비스 상태 확인
  Future<bool> checkServiceHealth();
  
  /// 지원하는 언어 목록
  List<String> get supportedLanguages;
  
  /// AI 서비스 이름
  String get serviceName;
  
  /// API 키가 설정되어 있는지 확인
  bool get isConfigured;
}

/// AI 서비스 타입 정의
enum AIServiceType {
  claude('Claude', 'Anthropic Claude API'),
  openai('OpenAI', 'OpenAI GPT API'),
  gemini('Gemini', 'Google Gemini API'),
  local('Local', '로컬 규칙 기반'),
  dummy('Dummy', '더미 데이터 서비스');

  const AIServiceType(this.id, this.displayName);
  
  final String id;
  final String displayName;
}

/// AI 서비스 설정
abstract class AIServiceConfig {
  String get apiKey;
  String get baseUrl;
  int get timeoutSeconds;
  Map<String, String> get headers;
}