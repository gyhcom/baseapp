import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/repositories/ai_service_repository.dart';
import '../../domain/entities/ai_routine_request.dart';
import '../../domain/entities/ai_routine_response.dart';
import '../../domain/entities/daily_routine.dart';
import '../../domain/entities/routine_item.dart';
import 'package:flutter/foundation.dart';

/// Claude API 서비스 구현
class ClaudeAIServiceImpl implements AIServiceRepository {
  final Dio _dio;
  final String _apiKey;
  
  ClaudeAIServiceImpl({
    required String apiKey,
    Dio? dio,
  }) : _apiKey = apiKey,
       _dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.anthropic.com',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2024-06-01', // 최신 버전으로 업데이트
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    );
  }


  @override
  Future<AIRoutineResponse> generateRoutine(AIRoutineRequest request) async {
    try {
      // API 키 검증
      if (!isConfigured) {
        return AIRoutineResponse.failure(
          error: 'Claude API 키가 설정되지 않았습니다. 설정 화면에서 API 키를 입력해주세요.',
        );
      }
      
      final prompt = _buildPrompt(request);
      
      final response = await _dio.post('/v1/messages', data: {
        'model': 'claude-3-haiku-20240307', // 더 빠르고 경제적인 모델
        'max_tokens': 2000,
        'messages': [
          {
            'role': 'user', 
            'content': [
              {
                'type': 'text',
                'text': prompt
              }
            ]
          }
        ]
      });

      if (response.statusCode == 200) {
        final aiResponse = response.data['content'][0]['text'] as String;
        final routine = _parseAIResponse(aiResponse, request);
        
        return AIRoutineResponse.success(
          routine: routine,
          tokensUsed: response.data['usage']?['output_tokens'] ?? 0,
        );
      } else {
        return AIRoutineResponse.failure(
          error: 'API 호출 실패: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Claude AI Error: $e');
      
      // DioException에서 더 자세한 정보 추출
      if (e is DioException) {
        debugPrint('Response data: ${e.response?.data}');
        debugPrint('Response headers: ${e.response?.headers}');
        debugPrint('Request data: ${e.requestOptions.data}');
        
        final errorMessage = e.response?.data?['error']?['message'] ?? 
                           'API 요청 실패 (${e.response?.statusCode})';
        
        return AIRoutineResponse.failure(
          error: 'Claude AI 오류: $errorMessage',
        );
      }
      
      return AIRoutineResponse.failure(
        error: 'AI 서비스 오류: ${e.toString()}',
      );
    }
  }

  /// 프롬프트 생성
  String _buildPrompt(AIRoutineRequest request) {
    return '''
당신은 개인화된 루틴을 생성하는 전문가입니다. 
다음 정보를 바탕으로 ${request.durationDays}일간의 일상 루틴을 생성해주세요.

**사용자 정보:**
- 이름: ${request.name}
- 나이: ${request.age}세 (${request.ageGroup})
- 직업: ${request.job}
- 취미: ${request.hobbiesText}
- 원하는 컨셉: ${request.concept.displayName} (${request.concept.description})
- 추가 정보: ${request.additionalInfo.isNotEmpty ? request.additionalInfo : '없음'}

**요구사항:**
1. 위 사용자의 특성을 반영한 개인화된 루틴
2. 선택한 컨셉(${request.concept.displayName})에 맞는 활동들
3. 현실적이고 실행 가능한 시간표
4. 각 활동별 구체적인 시간과 설명

**출력 형식 (JSON):**
```json
{
  "title": "루틴 제목",
  "description": "루틴 설명",
  "items": [
    {
      "title": "활동명",
      "description": "활동 설명",
      "category": "morning|work|exercise|hobby|social|selfCare|evening",
      "timeOfDay": "HH:MM",
      "durationMinutes": 숫자,
      "priority": 1-5,
      "isFlexible": true/false,
      "tags": ["태그1", "태그2"]
    }
  ]
}
```

개인의 특성과 컨셉을 잘 반영한 창의적이고 실용적인 루틴을 만들어주세요.
''';
  }

  /// AI 응답 파싱
  DailyRoutine _parseAIResponse(String aiResponse, AIRoutineRequest request) {
    try {
      // JSON 부분만 추출
      final jsonStart = aiResponse.indexOf('{');
      final jsonEnd = aiResponse.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0) {
        throw Exception('유효한 JSON을 찾을 수 없습니다');
      }
      
      final jsonString = aiResponse.substring(jsonStart, jsonEnd);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      final items = (data['items'] as List).map((item) {
        return RoutineItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: item['title'] as String,
          description: item['description'] as String,
          startTime: _parseTimeOfDay(item['timeOfDay'] as String? ?? '08:00'),
          duration: Duration(minutes: item['durationMinutes'] as int? ?? 30),
          category: item['category'] as String? ?? '일반',
          priority: _parsePriority(item['priority'] as int? ?? 3),
          isCompleted: false,
          tags: (item['tags'] as List?)?.cast<String>() ?? [],
        );
      }).toList();

      return DailyRoutine(
        id: 'ai_routine_${DateTime.now().millisecondsSinceEpoch}',
        title: data['title'] as String? ?? '${request.name}님의 ${request.concept.displayName} 루틴',
        concept: request.concept,
        items: items,
        generatedFor: request.toUserProfile(),
        description: data['description'] as String? ?? '',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('AI Response Parsing Error: $e');
      // 파싱 실패 시 기본 루틴 반환
      return _createFallbackRoutine(request);
    }
  }

  /// 시간 문자열을 TimeOfDay로 변환
  TimeOfDay _parseTimeOfDay(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 8, minute: 0); // 기본값
    }
  }

  /// 우선순위 숫자를 enum으로 변환
  RoutinePriority _parsePriority(int priority) {
    switch (priority) {
      case 1:
      case 2:
        return RoutinePriority.high;
      case 3:
        return RoutinePriority.medium;
      case 4:
      case 5:
        return RoutinePriority.low;
      default:
        return RoutinePriority.medium;
    }
  }

  /// AI 파싱 실패 시 기본 루틴 생성
  DailyRoutine _createFallbackRoutine(AIRoutineRequest request) {
    final items = [
      RoutineItem(
        id: 'fallback_1',
        title: '아침 시작',
        description: '하루를 시작하는 준비 시간',
        startTime: const TimeOfDay(hour: 7, minute: 0),
        duration: const Duration(minutes: 30),
        category: '아침',
        priority: RoutinePriority.high,
      ),
      RoutineItem(
        id: 'fallback_2',
        title: '${request.concept.displayName} 활동',
        description: '선택하신 컨셉에 맞는 특별한 시간',
        startTime: const TimeOfDay(hour: 14, minute: 0),
        duration: const Duration(hours: 1),
        category: '취미',
        priority: RoutinePriority.medium,
      ),
      RoutineItem(
        id: 'fallback_3',
        title: '하루 마무리',
        description: '편안한 휴식과 내일 준비',
        startTime: const TimeOfDay(hour: 22, minute: 0),
        duration: const Duration(minutes: 30),
        category: '저녁',
        priority: RoutinePriority.high,
      ),
    ];

    return DailyRoutine(
      id: 'fallback_routine_${DateTime.now().millisecondsSinceEpoch}',
      title: '${request.name}님의 기본 루틴',
      concept: request.concept,
      items: items,
      generatedFor: request.toUserProfile(),
      description: 'AI 생성에 문제가 있어 기본 루틴을 제공합니다.',
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<bool> checkServiceHealth() async {
    try {
      // 간단한 헬스체크 요청
      final response = await _dio.post(
        '/v1/messages',
        data: {
          'model': 'claude-3-haiku-20240307',
          'max_tokens': 10,
          'messages': [
            {
              'role': 'user', 
              'content': [
                {
                  'type': 'text',
                  'text': 'Hello'
                }
              ]
            }
          ],
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Claude 서비스 헬스체크 실패: $e');
      return false;
    }
  }

  @override
  List<String> get supportedLanguages => ['ko', 'en', 'ja', 'zh'];

  @override
  String get serviceName => 'Claude AI (Anthropic)';

  @override
  bool get isConfigured => _apiKey.isNotEmpty && !_apiKey.contains('dev-test-key');
}

