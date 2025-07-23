import '../../domain/repositories/ai_service_repository.dart';

/// AI 서비스 설정
class AIConfig {
  /// 현재 사용할 AI 서비스 타입
  /// 개발 중에는 local, 배포 시에는 claude 사용
  static const AIServiceType currentService = AIServiceType.local; // 임시로 로컬 모드
  
  /// 지원하는 AI 서비스 타입들
  static const List<AIServiceType> supportedServices = [
    AIServiceType.local,
    AIServiceType.claude,
    AIServiceType.openai, // 향후 확장용
  ];
  
  /// 현재 서비스가 더미인지 확인
  static bool get isDummyMode => currentService == AIServiceType.local;
  
  /// 현재 서비스가 실제 AI인지 확인  
  static bool get isRealAI => currentService != AIServiceType.local;
  
  /// 서비스별 설정
  static AppAIServiceConfig get config {
    switch (currentService) {
      case AIServiceType.local:
        return const AppAIServiceConfig(
          name: 'Local Dummy Service',
          description: '개발/테스트용 더미 데이터',
          requiresApiKey: false,
          maxTokens: 2000,
          averageResponseTime: Duration(seconds: 3),
        );
        
      case AIServiceType.claude:
        return const AppAIServiceConfig(
          name: 'Claude AI (Anthropic)',
          description: '실제 Claude API 사용',
          requiresApiKey: true,
          maxTokens: 4000,
          averageResponseTime: Duration(seconds: 8),
        );
        
      case AIServiceType.openai:
        return const AppAIServiceConfig(
          name: 'ChatGPT (OpenAI)',
          description: '실제 OpenAI API 사용',
          requiresApiKey: true,
          maxTokens: 4000,
          averageResponseTime: Duration(seconds: 6),
        );
        
      case AIServiceType.gemini:
        return const AppAIServiceConfig(
          name: 'Gemini (Google)',
          description: '실제 Gemini API 사용',
          requiresApiKey: true,
          maxTokens: 4000,
          averageResponseTime: Duration(seconds: 7),
        );
        
      case AIServiceType.dummy:
        return const AppAIServiceConfig(
          name: 'Dummy Service',
          description: '테스트용 더미 서비스',
          requiresApiKey: false,
          maxTokens: 2000,
          averageResponseTime: Duration(seconds: 2),
        );
    }
  }
}

/// 앱별 AI 서비스 설정 정보
class AppAIServiceConfig {
  final String name;
  final String description;
  final bool requiresApiKey;
  final int maxTokens;
  final Duration averageResponseTime;
  
  const AppAIServiceConfig({
    required this.name,
    required this.description,
    required this.requiresApiKey,
    required this.maxTokens,
    required this.averageResponseTime,
  });
}