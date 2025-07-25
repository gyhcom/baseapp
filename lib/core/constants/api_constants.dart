import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// API 관련 상수들
class ApiConstants {
  // Claude API 설정
  // ⚠️ 프로덕션에서는 반드시 환경변수 사용! 
  // 테스트용으로만 여기에 직접 입력하세요
  static const String claudeApiKey = ''; // 보안을 위해 환경변수 사용
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
    final envApiKey = dotenv.env['CLAUDE_API_KEY'] ?? '';
    
    if (envApiKey.isNotEmpty && envApiKey.startsWith('sk-ant-api03-')) {
      return envApiKey;
    }
    
    // API 키가 없으면 안내 메시지와 함께 빈 문자열 반환
    debugPrint('⚠️  Claude API 키가 필요합니다!');
    debugPrint('1. .env 파일에 CLAUDE_API_KEY 설정');
    debugPrint('2. 또는 환경변수 설정: export CLAUDE_API_KEY="your-key"');
    return '';
  }
  
  static bool get isDebugMode => current == Environment.dev;
}