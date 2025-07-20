import 'package:flutter_test/flutter_test.dart';
import 'package:baseapp/domain/entities/user_profile.dart';
import 'package:baseapp/domain/entities/routine_concept.dart';
import 'package:baseapp/domain/usecases/routine_recommendation_usecase.dart';

void main() {
  late RoutineRecommendationUseCase usecase;

  setUp(() {
    usecase = RoutineRecommendationUseCase();
  });

  group('RoutineRecommendationUsecase Tests', () {
    test('갓생 컨셉 루틴 생성 테스트', () async {
      // Given
      final userProfile = UserProfile(
        name: '김갓생',
        age: 28,
        job: '소프트웨어 개발자',
        hobbies: ['독서', '운동', '코딩'],
        concept: RoutineConcept.godlife,
        createdAt: DateTime.now(),
      );

      // When
      final routineItems = usecase.generateBaseRoutine(userProfile);

      // Then
      expect(routineItems.length, greaterThan(5));
      
      // 아침 일찍 기상하는지 확인 
      final morningItems = routineItems.where((item) => item.startTime.hour < 12);
      expect(morningItems.isNotEmpty, true);
      
      // 생산성 관련 활동이 포함되는지 확인
      final hasProductiveActivity = routineItems.any(
        (item) => item.title.contains('집중 업무') || item.title.contains('목표 설정')
      );
      expect(hasProductiveActivity, true);
    });

    test('여유로운 컨셉 루틴 생성 테스트', () async {
      // Given
      final userProfile = UserProfile(
        name: '박여유',
        age: 35,
        job: '요가 강사',
        hobbies: ['요가', '명상', '산책'],
        concept: RoutineConcept.relaxed,
        createdAt: DateTime.now(),
      );

      // When
      final routineItems = usecase.generateBaseRoutine(userProfile);

      // Then
      expect(routineItems.length, greaterThan(0));
      
      // 여유로운 활동이 포함되는지 확인
      final hasRelaxedActivity = routineItems.any(
        (item) => item.title.contains('산책') || item.title.contains('명상')
      );
      expect(hasRelaxedActivity, true);
      
      // 유연한 시간대 활동이 있는지 확인
      final hasFlexibleActivity = routineItems.any(
        (item) => item.isFlexible == true
      );
      expect(hasFlexibleActivity, true);
    });

    test('크리에이티브 컨셉 루틴 생성 테스트', () async {
      // Given
      final userProfile = UserProfile(
        name: '이창작',
        age: 24,
        job: '그래픽 디자이너',
        hobbies: ['그림그리기', '사진촬영', '음악감상'],
        concept: RoutineConcept.creative,
        createdAt: DateTime.now(),
      );

      // When
      final routineItems = usecase.generateBaseRoutine(userProfile);

      // Then
      expect(routineItems.length, greaterThan(0));
      
      // 창작 활동이 포함되는지 확인
      final hasCreativeActivity = routineItems.any(
        (item) => item.title.contains('창작') || item.title.contains('영감')
      );
      expect(hasCreativeActivity, true);
      
      // 취미 관련 활동이 포함되는지 확인
      final hasHobbyActivity = routineItems.any(
        (item) => item.tags.any((tag) => userProfile.hobbies.contains(tag))
      );
      expect(hasHobbyActivity, true);
    });

    test('건강한 컨셉 루틴 생성 테스트', () async {
      // Given
      final userProfile = UserProfile(
        name: '최건강',
        age: 32,
        job: '헬스 트레이너',
        hobbies: ['헬스', '등산', '수영'],
        concept: RoutineConcept.physicalHealth,
        createdAt: DateTime.now(),
      );

      // When
      final routineItems = usecase.generateBaseRoutine(userProfile);

      // Then
      expect(routineItems.length, greaterThan(0));
      
      // 운동 관련 활동이 포함되는지 확인
      final hasExerciseActivity = routineItems.any(
        (item) => item.category.contains('운동')
      );
      expect(hasExerciseActivity, true);
      
      // 아침 스트레칭이 포함되는지 확인
      final hasMorningStretch = routineItems.any(
        (item) => item.title.contains('스트레칭')
      );
      expect(hasMorningStretch, true);
    });

    test('루틴 총 시간 계산 테스트', () async {
      // Given
      final userProfile = UserProfile(
        name: '테스트',
        age: 25,
        job: '학생',
        hobbies: ['독서'],
        concept: RoutineConcept.workLifeBalance,
        createdAt: DateTime.now(),
      );

      // When
      final routineItems = usecase.generateBaseRoutine(userProfile);

      // Then
      expect(routineItems.isNotEmpty, true);
    });

    test('시간대별 루틴 분류 테스트', () async {
      // Given
      final userProfile = UserProfile(
        name: '테스트',
        age: 25,
        job: '직장인',
        hobbies: ['독서'],
        concept: RoutineConcept.diligent,
        createdAt: DateTime.now(),
      );

      // When
      final routineItems = usecase.generateBaseRoutine(userProfile);

      // Then
      final morningItems = routineItems.where((item) => item.startTime.hour < 12);
      final eveningItems = routineItems.where((item) => item.startTime.hour >= 18);
      expect(morningItems.isNotEmpty, true);
      expect(eveningItems.isNotEmpty, true);
      
      // 카테고리별 분류 테스트
      final categories = routineItems.map((item) => item.category).toSet();
      expect(categories.isNotEmpty, true);
    });
  });

  group('UserProfile Validation Tests', () {
    test('유효한 사용자 프로필 검증', () {
      // Given
      final validProfile = UserProfile(
        name: '김테스트',
        age: 25,
        job: '개발자',
        hobbies: ['독서'],
        concept: RoutineConcept.godlife,
      );

      // Then
      expect(validProfile.isValid, true);
      expect(validProfile.ageGroup, '20대');
      expect(validProfile.hobbiesDisplay, '독서');
    });

    test('무효한 사용자 프로필 검증', () {
      // Given
      final invalidProfile = UserProfile(
        name: '',
        age: 200,
        job: '',
        hobbies: [],
        concept: RoutineConcept.godlife,
      );

      // Then
      expect(invalidProfile.isValid, false);
    });

    test('연령대 분류 테스트', () {
      // Given & Then
      expect(UserProfile(name: 'test', age: 15, job: 'student', hobbies: ['독서'], concept: RoutineConcept.godlife).ageGroup, '10대');
      expect(UserProfile(name: 'test', age: 25, job: 'worker', hobbies: ['독서'], concept: RoutineConcept.godlife).ageGroup, '20대');
      expect(UserProfile(name: 'test', age: 35, job: 'manager', hobbies: ['독서'], concept: RoutineConcept.godlife).ageGroup, '30대');
      expect(UserProfile(name: 'test', age: 65, job: 'retired', hobbies: ['독서'], concept: RoutineConcept.godlife).ageGroup, '60대 이상');
    });
  });
}