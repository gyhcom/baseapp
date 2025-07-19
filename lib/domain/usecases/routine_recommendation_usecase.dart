import '../entities/user_profile.dart';
import '../entities/daily_routine.dart';
import '../entities/routine_item.dart';
import '../entities/routine_concept.dart';

class RoutineRecommendationUsecase {
  
  Future<DailyRoutine> generateRecommendedRoutine(UserProfile userProfile) async {
    final routineItems = await _generateRoutineItems(userProfile);
    
    return DailyRoutine(
      id: _generateRoutineId(),
      title: '${userProfile.name}님의 ${userProfile.concept.displayName} 루틴',
      concept: userProfile.concept,
      items: routineItems,
      generatedFor: userProfile,
      description: _generateDescription(userProfile),
      createdAt: DateTime.now(),
    );
  }

  Future<List<RoutineItem>> _generateRoutineItems(UserProfile userProfile) async {
    final List<RoutineItem> items = [];
    
    // 기본 아침 루틴 추가
    items.addAll(_getMorningRoutine(userProfile));
    
    // 컨셉별 특화 활동 추가
    items.addAll(_getConceptSpecificActivities(userProfile));
    
    // 취미 기반 활동 추가
    items.addAll(_getHobbyBasedActivities(userProfile));
    
    // 직업 기반 활동 추가
    items.addAll(_getJobBasedActivities(userProfile));
    
    // 기본 저녁 루틴 추가
    items.addAll(_getEveningRoutine(userProfile));
    
    // 우선순위에 따라 정렬
    items.sort((a, b) => a.priority.compareTo(b.priority));
    
    return items;
  }

  List<RoutineItem> _getMorningRoutine(UserProfile userProfile) {
    final base = [
      RoutineItem(
        id: 'morning_1',
        title: '기상 및 세면',
        description: '상쾌한 하루를 위한 아침 준비',
        category: RoutineCategory.morning,
        estimatedDuration: const Duration(minutes: 30),
        timeOfDay: _getWakeUpTime(userProfile.concept),
        priority: 1,
      ),
    ];

    // 컨셉에 따른 아침 루틴 추가
    switch (userProfile.concept) {
      case RoutineConcept.godlife:
        base.add(RoutineItem(
          id: 'morning_2',
          title: '하루 계획 세우기',
          description: '오늘의 목표와 우선순위 설정',
          category: RoutineCategory.morning,
          estimatedDuration: const Duration(minutes: 15),
          timeOfDay: '06:15',
          priority: 2,
        ));
        break;
      case RoutineConcept.diligent:
        base.add(RoutineItem(
          id: 'morning_2',
          title: '아침 체크리스트',
          description: '오늘 할 일 목록 확인',
          category: RoutineCategory.morning,
          estimatedDuration: const Duration(minutes: 10),
          timeOfDay: '06:30',
          priority: 2,
        ));
        break;
      case RoutineConcept.physicalHealth:
        base.add(RoutineItem(
          id: 'morning_2',
          title: '아침 스트레칭',
          description: '몸을 깨우는 가벼운 스트레칭',
          category: RoutineCategory.exercise,
          estimatedDuration: const Duration(minutes: 20),
          timeOfDay: '06:30',
          priority: 2,
        ));
        break;
      case RoutineConcept.mindfulness:
        base.add(RoutineItem(
          id: 'morning_2',
          title: '아침 감사 인사',
          description: '새로운 하루에 대한 감사 표현',
          category: RoutineCategory.morning,
          estimatedDuration: const Duration(minutes: 5),
          timeOfDay: '08:00',
          priority: 2,
        ));
        break;
      case RoutineConcept.challenge:
        base.add(RoutineItem(
          id: 'morning_2',
          title: '도전 의지 다지기',
          description: '오늘의 챌린지에 대한 다짐',
          category: RoutineCategory.morning,
          estimatedDuration: const Duration(minutes: 5),
          timeOfDay: '07:00',
          priority: 2,
        ));
        break;
      default:
        break;
    }

    return base;
  }

  List<RoutineItem> _getConceptSpecificActivities(UserProfile userProfile) {
    switch (userProfile.concept) {
      // 🔥 자기계발형
      case RoutineConcept.godlife:
        return [
          RoutineItem(
            id: 'godlife_1',
            title: '새벽 독서',
            description: '하루를 시작하는 지식 충전',
            category: RoutineCategory.morning,
            estimatedDuration: const Duration(minutes: 45),
            timeOfDay: '06:00',
            priority: 1,
          ),
          RoutineItem(
            id: 'godlife_2',
            title: '목표 달성 체크',
            description: '일일 목표 설정 및 진행상황 체크',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(minutes: 20),
            timeOfDay: '21:30',
            priority: 1,
          ),
        ];
      
      case RoutineConcept.diligent:
        return [
          RoutineItem(
            id: 'diligent_1',
            title: '생산적 업무 시간',
            description: '하루 중 가장 집중력이 높은 시간 활용',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(hours: 2),
            timeOfDay: '09:00',
            priority: 1,
          ),
          RoutineItem(
            id: 'diligent_2',
            title: '자기계발 학습',
            description: '꾸준한 성장을 위한 학습',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(minutes: 45),
            timeOfDay: '19:00',
            priority: 2,
          ),
        ];

      // ☁️ 휴식형
      case RoutineConcept.relaxed:
        return [
          RoutineItem(
            id: 'relaxed_1',
            title: '여유로운 산책',
            description: '자연을 만끽하며 걷기',
            category: RoutineCategory.exercise,
            estimatedDuration: const Duration(minutes: 40),
            timeOfDay: '16:00',
            priority: 2,
            isFlexible: true,
          ),
          RoutineItem(
            id: 'relaxed_2',
            title: '차 한잔의 여유',
            description: '좋아하는 차나 커피와 함께하는 휴식',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 30),
            timeOfDay: '15:00',
            priority: 2,
            isFlexible: true,
          ),
        ];
      
      case RoutineConcept.restful:
        return [
          RoutineItem(
            id: 'restful_1',
            title: '자유로운 휴식',
            description: '좋아하는 것을 자유롭게 하는 시간',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(hours: 1),
            priority: 3,
            isFlexible: true,
          ),
          RoutineItem(
            id: 'restful_2',
            title: '낮잠 타임',
            description: '짧은 낮잠으로 에너지 충전',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 30),
            timeOfDay: '14:00',
            priority: 2,
            isFlexible: true,
          ),
        ];

      // 🎨 창의형
      case RoutineConcept.creative:
        return [
          RoutineItem(
            id: 'creative_1',
            title: '창작 몰입 시간',
            description: '예술적 영감을 표현하는 시간',
            category: RoutineCategory.hobby,
            estimatedDuration: const Duration(hours: 1, minutes: 30),
            timeOfDay: '14:00',
            priority: 1,
            isFlexible: true,
          ),
          RoutineItem(
            id: 'creative_2',
            title: '영감 수집',
            description: '다양한 매체로 영감 얻기',
            category: RoutineCategory.hobby,
            estimatedDuration: const Duration(minutes: 45),
            timeOfDay: '21:00',
            priority: 2,
            isFlexible: true,
          ),
        ];

      // 🧠 집중형
      case RoutineConcept.minimal:
        return [
          RoutineItem(
            id: 'minimal_1',
            title: '딥워크 시간',
            description: '방해받지 않는 집중적인 작업',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(hours: 2, minutes: 30),
            timeOfDay: '09:00',
            priority: 1,
          ),
          RoutineItem(
            id: 'minimal_2',
            title: '핵심 정리',
            description: '오늘의 중요한 것들만 정리',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(minutes: 15),
            timeOfDay: '21:00',
            priority: 1,
          ),
        ];

      // 💼 실용형
      case RoutineConcept.workLifeBalance:
        return [
          RoutineItem(
            id: 'balance_1',
            title: '효율적 업무',
            description: '정해진 시간 내 업무 완료',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(hours: 1, minutes: 30),
            timeOfDay: '10:00',
            priority: 1,
          ),
          RoutineItem(
            id: 'balance_2',
            title: '개인 시간',
            description: '나만을 위한 소중한 시간',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(hours: 1),
            timeOfDay: '19:00',
            priority: 1,
            isFlexible: true,
          ),
        ];

      // 🐢 느긋형
      case RoutineConcept.lazyButRegular:
        return [
          RoutineItem(
            id: 'lazy_1',
            title: '느긋한 활동',
            description: '부담없이 할 수 있는 간단한 활동',
            category: RoutineCategory.hobby,
            estimatedDuration: const Duration(minutes: 45),
            priority: 3,
            isFlexible: true,
          ),
          RoutineItem(
            id: 'lazy_2',
            title: '최소한의 정리',
            description: '꼭 필요한 것만 간단히 정리',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 15),
            timeOfDay: '20:00',
            priority: 2,
          ),
        ];

      // 🧘‍♀️ 웰니스형
      case RoutineConcept.mindfulness:
        return [
          RoutineItem(
            id: 'mindfulness_1',
            title: '명상 시간',
            description: '마음을 정화하는 명상',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 20),
            timeOfDay: '07:00',
            priority: 1,
          ),
          RoutineItem(
            id: 'mindfulness_2',
            title: '감정 일기 쓰기',
            description: '오늘의 감정과 생각 기록',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 15),
            timeOfDay: '21:30',
            priority: 1,
          ),
        ];

      // 💪 건강형
      case RoutineConcept.physicalHealth:
        return [
          RoutineItem(
            id: 'health_1',
            title: '체력 운동',
            description: '신체 능력 향상을 위한 운동',
            category: RoutineCategory.exercise,
            estimatedDuration: const Duration(hours: 1),
            timeOfDay: '07:00',
            priority: 1,
          ),
          RoutineItem(
            id: 'health_2',
            title: '영양 관리',
            description: '건강한 식단 계획 및 준비',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 30),
            timeOfDay: '12:00',
            priority: 2,
          ),
        ];

      // 🛡 회복형
      case RoutineConcept.mentalRecovery:
        return [
          RoutineItem(
            id: 'recovery_1',
            title: '부담없는 활동',
            description: '스트레스 없이 할 수 있는 활동',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 45),
            priority: 3,
            isFlexible: true,
          ),
          RoutineItem(
            id: 'recovery_2',
            title: '심호흡과 휴식',
            description: '깊은 호흡으로 마음 안정',
            category: RoutineCategory.selfCare,
            estimatedDuration: const Duration(minutes: 10),
            timeOfDay: '20:00',
            priority: 1,
          ),
        ];

      // 🎯 챌린지형
      case RoutineConcept.challenge:
        return [
          RoutineItem(
            id: 'challenge_1',
            title: '일일 챌린지',
            description: '3일간 실행할 작은 도전',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(minutes: 30),
            timeOfDay: '19:00',
            priority: 1,
          ),
          RoutineItem(
            id: 'challenge_2',
            title: '성취 체크',
            description: '오늘의 도전 완료 여부 체크',
            category: RoutineCategory.work,
            estimatedDuration: const Duration(minutes: 10),
            timeOfDay: '21:00',
            priority: 1,
          ),
        ];
      
      default:
        return [];
    }
  }

  List<RoutineItem> _getHobbyBasedActivities(UserProfile userProfile) {
    final List<RoutineItem> items = [];
    
    for (int i = 0; i < userProfile.hobbies.length && i < 2; i++) {
      final hobby = userProfile.hobbies[i];
      items.add(RoutineItem(
        id: 'hobby_${i + 1}',
        title: '$hobby 시간',
        description: '$hobby를 즐기는 시간',
        category: RoutineCategory.hobby,
        estimatedDuration: const Duration(minutes: 45),
        priority: 3,
        isFlexible: true,
        tags: [hobby],
      ));
    }
    
    return items;
  }

  List<RoutineItem> _getJobBasedActivities(UserProfile userProfile) {
    // 직업에 따른 특화 활동 (간단한 예시)
    if (userProfile.job.contains('개발') || userProfile.job.contains('프로그래머')) {
      return [
        RoutineItem(
          id: 'job_1',
          title: '기술 블로그/뉴스 읽기',
          description: '최신 기술 트렌드 파악',
          category: RoutineCategory.work,
          estimatedDuration: const Duration(minutes: 30),
          timeOfDay: '08:00',
          priority: 3,
        ),
      ];
    } else if (userProfile.job.contains('디자인')) {
      return [
        RoutineItem(
          id: 'job_1',
          title: '디자인 영감 수집',
          description: '디자인 포트폴리오 및 트렌드 확인',
          category: RoutineCategory.work,
          estimatedDuration: const Duration(minutes: 30),
          timeOfDay: '08:30',
          priority: 3,
        ),
      ];
    }
    
    return [];
  }

  List<RoutineItem> _getEveningRoutine(UserProfile userProfile) {
    return [
      RoutineItem(
        id: 'evening_1',
        title: '하루 정리',
        description: '오늘을 돌아보고 내일을 준비',
        category: RoutineCategory.evening,
        estimatedDuration: const Duration(minutes: 15),
        timeOfDay: '22:00',
        priority: 2,
      ),
      RoutineItem(
        id: 'evening_2',
        title: '취침 준비',
        description: '편안한 잠자리를 위한 준비',
        category: RoutineCategory.evening,
        estimatedDuration: const Duration(minutes: 30),
        timeOfDay: _getBedTime(userProfile.concept),
        priority: 1,
      ),
    ];
  }

  String _getWakeUpTime(RoutineConcept concept) {
    return concept.recommendedWakeUpTime;
  }

  String _getBedTime(RoutineConcept concept) {
    return concept.recommendedBedTime;
  }

  String _generateRoutineId() {
    return 'routine_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateDescription(UserProfile userProfile) {
    return '${userProfile.ageGroup} ${userProfile.job}인 ${userProfile.name}님을 위한 '
           '${userProfile.concept.displayName} 컨셉의 개인화된 루틴입니다. '
           '${userProfile.hobbiesDisplay} 취미를 고려하여 구성되었습니다.';
  }
}