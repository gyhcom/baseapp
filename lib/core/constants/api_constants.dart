/// API 관련 상수들
class ApiConstants {
  // Claude API 설정
  // ⚠️ 프로덕션에서는 반드시 환경변수 사용! 
  // 테스트용으로만 여기에 직접 입력하세요
  static const String claudeApiKey = '***REMOVED***'; // 실제 API 키 적용
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
        // 실제 API 키가 필요합니다: sk-ant-api03-xxx...
        const envApiKey = String.fromEnvironment('CLAUDE_API_KEY', 
            defaultValue: '');
        
        // 환경변수에 API 키가 있으면 우선 사용
        if (envApiKey.isNotEmpty && envApiKey.startsWith('sk-ant-api03-')) {
          return envApiKey;
        }
        
        // 환경변수가 없으면 코드에서 설정된 키 사용
        if (ApiConstants.claudeApiKey.startsWith('sk-ant-api03-') && 
            !ApiConstants.claudeApiKey.contains('your-api-key')) {
          return ApiConstants.claudeApiKey;
        }
        
        // API 키가 없으면 안내 메시지와 함께 빈 문자열 반환
        print('⚠️  Claude API 키가 필요합니다!');
        print('1. api_constants.dart에서 claudeApiKey 값을 실제 키로 변경');
        print('2. 또는 환경변수 설정: export CLAUDE_API_KEY="your-key"');
        return '';
      case Environment.prod:
        return ApiConstants.claudeApiKey;
    }
  }
  
  static bool get isDebugMode => current == Environment.dev;
}