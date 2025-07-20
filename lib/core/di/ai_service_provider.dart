import 'package:dio/dio.dart';
import '../config/ai_config.dart';
import '../constants/api_constants.dart';
import '../../domain/repositories/ai_service_repository.dart';
import '../../data/repositories/dummy_ai_service_impl.dart';
import '../../data/repositories/claude_ai_service_impl.dart';

/// AI 서비스 팩토리 - 설정에 따라 적절한 AI 서비스 반환
class AIServiceProvider {
  /// 현재 설정에 맞는 AI 서비스 인스턴스 생성
  static AIServiceRepository createService() {
    switch (AIConfig.currentService) {
      case AIServiceType.local:
        return DummyAIServiceImpl();
        
      case AIServiceType.claude:
        final dio = Dio();
        return ClaudeAIServiceImpl(
          apiKey: EnvironmentConfig.claudeApiKey,
          dio: dio,
        );
        
      case AIServiceType.openai:
        // TODO: OpenAI 서비스 구현 시 추가
        throw UnimplementedError('OpenAI 서비스는 아직 구현되지 않았습니다.');
        
      case AIServiceType.gemini:
        // TODO: Gemini 서비스 구현 시 추가
        throw UnimplementedError('Gemini 서비스는 아직 구현되지 않았습니다.');
    }
  }
  
  /// 현재 서비스 정보 반환
  static AppAIServiceConfig get currentConfig => AIConfig.config;
  
  /// 서비스 전환 가능 여부 확인
  static bool canSwitchTo(AIServiceType type) {
    switch (type) {
      case AIServiceType.local:
        return true; // 로컬은 항상 가능
        
      case AIServiceType.claude:
        // Claude API 키가 설정되어 있는지 확인
        final apiKey = EnvironmentConfig.claudeApiKey;
        return apiKey.isNotEmpty && !apiKey.contains('dev-test-key');
        
      case AIServiceType.openai:
        return false; // 아직 미구현
        
      case AIServiceType.gemini:
        return false; // 아직 미구현
    }
  }
  
  /// 현재 서비스 상태 정보
  static Map<String, dynamic> getServiceStatus() {
    final config = currentConfig;
    
    return {
      'service_type': AIConfig.currentService.name,
      'service_name': config.name,
      'is_dummy': AIConfig.isDummyMode,
      'requires_api_key': config.requiresApiKey,
      'is_available': AIConfig.isDummyMode || canSwitchTo(AIConfig.currentService),
      'max_tokens': config.maxTokens,
      'average_response_time_seconds': config.averageResponseTime.inSeconds,
    };
  }
}