/// API 관련 상수들
class ApiConstants {
  // Claude API 설정
  static const String claudeApiKey = 'sk-ant-api03-your-api-key-here'; // TODO: 실제 API 키로 교체
  static const String claudeApiUrl = 'https://api.anthropic.com';
  static const String claudeApiVersion = '2023-06-01';
  
  // API 타임아웃
  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 60;
  
  // 토큰 제한
  static const int maxTokens = 2000;
  static const String defaultModel = 'claude-3-sonnet-20240229';
  
  // 지원 언어
  static const List<String> supportedLanguages = ['ko', 'en', 'ja'];
  static const String defaultLanguage = 'ko';
}

/// 환경별 설정
enum Environment {
  dev('development'),
  prod('production');
  
  const Environment(this.name);
  final String name;
}

/// 현재 환경 설정
class EnvironmentConfig {
  static const Environment current = Environment.dev;
  
  static String get claudeApiKey {
    switch (current) {
      case Environment.dev:
        // 개발용 - 실제 Claude API 키를 여기에 설정하세요
        // 현재는 더미 키로 API 연동 테스트를 위해 기본 동작만 확인 가능
        return const String.fromEnvironment('CLAUDE_API_KEY', 
            defaultValue: 'sk-ant-api03-dev-test-key-for-routine-app');
      case Environment.prod:
        return ApiConstants.claudeApiKey;
    }
  }
  
  static bool get isDebugMode => current == Environment.dev;
}