import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/repositories/ai_service_repository.dart';
import '../../domain/entities/ai_routine_request.dart';
import '../../domain/entities/ai_routine_response.dart';
import '../../domain/entities/daily_routine.dart';
import '../../domain/entities/routine_item.dart';
import '../../domain/entities/routine_concept.dart';

/// 더미 데이터를 사용하는 AI 서비스 구현
/// 실제 API 비용 없이 전체 플로우 테스트 가능
class DummyAIServiceImpl implements AIServiceRepository {
  final Random _random = Random();

  @override
  Future<AIRoutineResponse> generateRoutine(AIRoutineRequest request) async {
    // 실제 API 호출처럼 지연시간 추가
    await Future.delayed(Duration(milliseconds: 2000 + _random.nextInt(3000)));

    try {
      // 컨셉별 맞춤형 더미 루틴 생성
      final routine = _generateDummyRoutine(request);
      
      return AIRoutineResponse(
        success: true,
        message: '${request.name}님만의 ${request.concept.displayName} 루틴이 성공적으로 생성되었습니다!',
        routine: routine,
        tokensUsed: _random.nextInt(1500) + 500, // 500-2000 토큰
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      return AIRoutineResponse(
        success: false,
        message: '루틴 생성 중 오류가 발생했습니다.',
        error: e.toString(),
        tokensUsed: 0,
        generatedAt: DateTime.now(),
      );
    }
  }


  /// 컨셉별 맞춤형 더미 루틴 생성
  DailyRoutine _generateDummyRoutine(AIRoutineRequest request) {
    final concept = request.concept;
    final age = request.age;
    final hobbies = request.hobbies;
    
    // 컨셉별 기본 루틴 템플릿 선택
    final items = _getRoutineItemsForConcept(concept, age, hobbies);
    
    return DailyRoutine(
      id: 'routine_${DateTime.now().millisecondsSinceEpoch}',
      title: '${request.name}님의 ${concept.displayName}',
      concept: concept,
      items: items,
      generatedFor: request.toUserProfile(),
      description: _getRoutineDescription(concept, request),
      createdAt: DateTime.now(),
      isFavorite: false,
      usageCount: 0,
    );
  }

  /// 컨셉별 루틴 아이템 생성
  List<RoutineItem> _getRoutineItemsForConcept(
    RoutineConcept concept, 
    int age, 
    List<String> hobbies
  ) {
    switch (concept) {
      case RoutineConcept.godlife:
        return _createGodlifeRoutine(age, hobbies);
      case RoutineConcept.diligent:
        return _createDiligentRoutine(age, hobbies);
      case RoutineConcept.relaxed:
        return _createRelaxedRoutine(age, hobbies);
      case RoutineConcept.restful:
        return _createRestfulRoutine(age, hobbies);
      case RoutineConcept.creative:
        return _createCreativeRoutine(age, hobbies);
      case RoutineConcept.minimal:
        return _createMinimalRoutine(age, hobbies);
      case RoutineConcept.workLifeBalance:
        return _createWorkLifeBalanceRoutine(age, hobbies);
      case RoutineConcept.lazyButRegular:
        return _createLazyButRegularRoutine(age, hobbies);
      case RoutineConcept.mindfulness:
        return _createMindfulnessRoutine(age, hobbies);
      case RoutineConcept.physicalHealth:
        return _createPhysicalHealthRoutine(age, hobbies);
      case RoutineConcept.mentalRecovery:
        return _createMentalRecoveryRoutine(age, hobbies);
      case RoutineConcept.challenge:
        return _createChallengeRoutine(age, hobbies);
    }
  }

  /// 갓생 루틴
  List<RoutineItem> _createGodlifeRoutine(int age, List<String> hobbies) {
    return [
      RoutineItem(
        id: '1',
        title: '물 한 잔과 함께 기상',
        description: '신진대사 활성화를 위한 첫 단계',
        startTime: const TimeOfDay(hour: 5, minute: 30),
        duration: const Duration(minutes: 10),
        category: '건강',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '2',
        title: '명상 및 감사 일기',
        description: '하루를 긍정적으로 시작하는 마음가짐 정리',
        startTime: const TimeOfDay(hour: 5, minute: 40),
        duration: const Duration(minutes: 20),
        category: '정신건강',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '3',
        title: '30분 운동 (홈트레이닝)',
        description: hobbies.contains('운동') 
            ? '좋아하는 운동으로 몸을 깨우세요' 
            : '간단한 스트레칭과 기본 운동',
        startTime: const TimeOfDay(hour: 6, minute: 0),
        duration: const Duration(minutes: 30),
        category: '운동',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '4',
        title: '건강한 아침식사',
        description: '단백질과 섬유질이 풍부한 균형잡힌 식사',
        startTime: const TimeOfDay(hour: 6, minute: 30),
        duration: const Duration(minutes: 30),
        category: '식사',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '5',
        title: '독서 및 학습',
        description: hobbies.contains('독서') 
            ? '관심 분야 도서로 지식 확장' 
            : '자기계발서나 전문서적 읽기',
        startTime: const TimeOfDay(hour: 7, minute: 0),
        duration: const Duration(minutes: 60),
        category: '자기계발',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '6',
        title: '목표 설정 및 계획 수립',
        description: '오늘의 우선순위 3가지와 주간 목표 점검',
        startTime: const TimeOfDay(hour: 8, minute: 0),
        duration: const Duration(minutes: 30),
        category: '계획',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '7',
        title: '집중 업무/학습 (1차)',
        description: '가장 중요한 업무를 최고 컨디션일 때 처리',
        startTime: const TimeOfDay(hour: 9, minute: 0),
        duration: const Duration(hours: 2),
        category: '업무',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '8',
        title: '가벼운 점심 및 휴식',
        description: '소화가 잘 되는 가벼운 식사로 오후 준비',
        startTime: const TimeOfDay(hour: 12, minute: 0),
        duration: const Duration(minutes: 60),
        category: '식사',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '9',
        title: '집중 업무/학습 (2차)',
        description: '오전에 이어 중요한 프로젝트 진행',
        startTime: const TimeOfDay(hour: 13, minute: 0),
        duration: const Duration(hours: 2),
        category: '업무',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '10',
        title: '취미 활동',
        description: hobbies.isNotEmpty 
            ? '${hobbies.first} 등 관심사로 재충전' 
            : '좋아하는 활동으로 스트레스 해소',
        startTime: const TimeOfDay(hour: 17, minute: 0),
        duration: const Duration(minutes: 90),
        category: '여가',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '11',
        title: '저녁식사 및 정리',
        description: '하루 마무리 겸 영양 보충',
        startTime: const TimeOfDay(hour: 19, minute: 0),
        duration: const Duration(minutes: 60),
        category: '식사',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '12',
        title: '일기 작성 및 내일 준비',
        description: '하루 돌아보기와 내일의 우선순위 정하기',
        startTime: const TimeOfDay(hour: 21, minute: 0),
        duration: const Duration(minutes: 30),
        category: '정리',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '13',
        title: '디지털 디톡스 시간',
        description: '폰/컴퓨터 없이 차분한 시간 보내기',
        startTime: const TimeOfDay(hour: 21, minute: 30),
        duration: const Duration(minutes: 30),
        category: '휴식',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
    ];
  }

  /// 여유로운 루틴
  List<RoutineItem> _createRelaxedRoutine(int age, List<String> hobbies) {
    return [
      RoutineItem(
        id: '1',
        title: '자연스러운 기상',
        description: '알람 없이 자연스럽게 눈 뜨기',
        startTime: const TimeOfDay(hour: 8, minute: 0),
        duration: const Duration(minutes: 15),
        category: '휴식',
        priority: RoutinePriority.low,
        isCompleted: false,
      ),
      RoutineItem(
        id: '2',
        title: '따뜻한 차 한 잔',
        description: '좋아하는 차나 커피로 여유로운 시작',
        startTime: const TimeOfDay(hour: 8, minute: 15),
        duration: const Duration(minutes: 30),
        category: '휴식',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '3',
        title: '가벼운 스트레칭',
        description: '몸을 깨우는 부드러운 움직임',
        startTime: const TimeOfDay(hour: 8, minute: 45),
        duration: const Duration(minutes: 15),
        category: '운동',
        priority: RoutinePriority.low,
        isCompleted: false,
      ),
      RoutineItem(
        id: '4',
        title: '천천히 아침식사',
        description: '서두르지 않고 맛있게 즐기는 식사',
        startTime: const TimeOfDay(hour: 9, minute: 0),
        duration: const Duration(minutes: 45),
        category: '식사',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '5',
        title: '여유로운 업무/활동',
        description: '스트레스 없이 자신의 페이스대로',
        startTime: const TimeOfDay(hour: 10, minute: 0),
        duration: const Duration(hours: 2),
        category: '업무',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '6',
        title: '산책 또는 자연감상',
        description: '근처 공원이나 카페에서 여유 시간',
        startTime: const TimeOfDay(hour: 14, minute: 0),
        duration: const Duration(minutes: 60),
        category: '여가',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '7',
        title: '취미 시간',
        description: hobbies.isNotEmpty 
            ? '${hobbies.join(', ')} 등 좋아하는 활동' 
            : '관심있는 활동 자유롭게',
        startTime: const TimeOfDay(hour: 16, minute: 0),
        duration: const Duration(hours: 2),
        category: '여가',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '8',
        title: '편안한 저녁식사',
        description: '좋아하는 음식으로 맛있는 저녁',
        startTime: const TimeOfDay(hour: 19, minute: 0),
        duration: const Duration(minutes: 60),
        category: '식사',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '9',
        title: '휴식 및 정리',
        description: '하루를 돌아보며 차분한 시간',
        startTime: const TimeOfDay(hour: 21, minute: 0),
        duration: const Duration(hours: 1),
        category: '휴식',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
    ];
  }

  /// 워라밸 루틴
  List<RoutineItem> _createWorkLifeBalanceRoutine(int age, List<String> hobbies) {
    return [
      RoutineItem(
        id: '1',
        title: '적당한 기상',
        description: '충분한 수면 후 상쾌한 아침',
        startTime: const TimeOfDay(hour: 7, minute: 0),
        duration: const Duration(minutes: 15),
        category: '휴식',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '2',
        title: '간단한 모닝 루틴',
        description: '세안, 양치, 간단한 스트레칭',
        startTime: const TimeOfDay(hour: 7, minute: 15),
        duration: const Duration(minutes: 30),
        category: '건강',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '3',
        title: '든든한 아침식사',
        description: '하루 에너지를 위한 균형잡힌 식사',
        startTime: const TimeOfDay(hour: 7, minute: 45),
        duration: const Duration(minutes: 30),
        category: '식사',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '4',
        title: '집중 업무 시간',
        description: '효율적인 업무 처리로 생산성 극대화',
        startTime: const TimeOfDay(hour: 9, minute: 0),
        duration: const Duration(hours: 4),
        category: '업무',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '5',
        title: '점심시간 및 휴식',
        description: '맛있는 점심과 충분한 휴식',
        startTime: const TimeOfDay(hour: 12, minute: 0),
        duration: const Duration(minutes: 60),
        category: '식사',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '6',
        title: '오후 업무 마무리',
        description: '남은 업무 정리 및 내일 계획',
        startTime: const TimeOfDay(hour: 13, minute: 0),
        duration: const Duration(hours: 3),
        category: '업무',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '7',
        title: '운동 또는 산책',
        description: '몸과 마음의 균형을 위한 활동',
        startTime: const TimeOfDay(hour: 17, minute: 0),
        duration: const Duration(minutes: 45),
        category: '운동',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
      RoutineItem(
        id: '8',
        title: '개인 시간',
        description: hobbies.isNotEmpty 
            ? '${hobbies.first} 등 취미 활동' 
            : '자유로운 개인 활동',
        startTime: const TimeOfDay(hour: 18, minute: 0),
        duration: const Duration(minutes: 90),
        category: '여가',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '9',
        title: '저녁식사 및 가족시간',
        description: '소중한 사람들과의 시간',
        startTime: const TimeOfDay(hour: 19, minute: 30),
        duration: const Duration(minutes: 90),
        category: '식사',
        priority: RoutinePriority.high,
        isCompleted: false,
      ),
      RoutineItem(
        id: '10',
        title: '휴식 및 정리',
        description: '하루 마무리와 내일 준비',
        startTime: const TimeOfDay(hour: 21, minute: 30),
        duration: const Duration(minutes: 90),
        category: '휴식',
        priority: RoutinePriority.medium,
        isCompleted: false,
      ),
    ];
  }

  // 나머지 컨셉들도 비슷하게 구현...
  List<RoutineItem> _createDiligentRoutine(int age, List<String> hobbies) {
    // 부지런한 루틴 구현
    return _createGodlifeRoutine(age, hobbies); // 임시로 갓생 루틴 사용
  }

  List<RoutineItem> _createRestfulRoutine(int age, List<String> hobbies) {
    return _createRelaxedRoutine(age, hobbies); // 임시로 여유로운 루틴 사용
  }

  List<RoutineItem> _createCreativeRoutine(int age, List<String> hobbies) {
    return _createRelaxedRoutine(age, hobbies);
  }

  List<RoutineItem> _createMinimalRoutine(int age, List<String> hobbies) {
    return _createWorkLifeBalanceRoutine(age, hobbies);
  }

  List<RoutineItem> _createLazyButRegularRoutine(int age, List<String> hobbies) {
    return _createRelaxedRoutine(age, hobbies);
  }

  List<RoutineItem> _createMindfulnessRoutine(int age, List<String> hobbies) {
    return _createRelaxedRoutine(age, hobbies);
  }

  List<RoutineItem> _createPhysicalHealthRoutine(int age, List<String> hobbies) {
    return _createGodlifeRoutine(age, hobbies);
  }

  List<RoutineItem> _createMentalRecoveryRoutine(int age, List<String> hobbies) {
    return _createRelaxedRoutine(age, hobbies);
  }

  List<RoutineItem> _createChallengeRoutine(int age, List<String> hobbies) {
    return _createGodlifeRoutine(age, hobbies);
  }

  /// 컨셉별 루틴 설명 생성
  String _getRoutineDescription(RoutineConcept concept, AIRoutineRequest request) {
    final age = request.age;
    final hobbies = request.hobbies.join(', ');
    
    switch (concept) {
      case RoutineConcept.godlife:
        return '$age세 ${request.job}인 ${request.name}님을 위한 갓생 루틴입니다. '
               '새벽 기상부터 체계적인 자기계발까지, 목표 달성을 위한 완벽한 하루를 만들어보세요. '
               '관심사($hobbies)도 루틴에 포함되어 있어 지속 가능한 성장을 도와드립니다.';
               
      case RoutineConcept.relaxed:
        return '스트레스 없는 여유로운 하루를 위한 루틴입니다. '
               '${request.name}님의 페이스에 맞춰 천천히 진행하며, '
               '$hobbies 등 좋아하시는 활동으로 마음의 여유를 찾아보세요.';
               
      case RoutineConcept.workLifeBalance:
        return '일과 삶의 균형을 중시하는 ${request.name}님을 위한 루틴입니다. '
               '효율적인 업무 처리와 충분한 개인 시간을 통해 지속 가능한 라이프스타일을 만들어보세요. '
               '$hobbies 활동 시간도 충분히 확보되어 있습니다.';
               
      default:
        return '${request.name}님만의 맞춤형 ${concept.displayName} 루틴입니다. '
               '개인의 특성과 관심사를 반영하여 설계되었습니다.';
    }
  }

  @override
  Future<bool> checkServiceHealth() async {
    // 더미 서비스는 항상 정상
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  List<String> get supportedLanguages => ['ko', 'en'];

  @override
  String get serviceName => 'Dummy AI Service (로컬 테스트용)';

  @override
  bool get isConfigured => true; // 더미 서비스는 항상 설정됨
}