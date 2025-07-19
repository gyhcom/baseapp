import 'user_profile.dart';
import 'routine_concept.dart';

class SampleData {
  static List<UserProfile> getSampleUserProfiles() {
    return [
      // 🔥 갓생살기 - 20대 개발자
      UserProfile(
        name: '김갓생',
        age: 28,
        job: '소프트웨어 개발자',
        hobbies: ['독서', '운동', '코딩', '블로그 작성'],
        concept: RoutineConcept.godlife,
        additionalInfo: '새벽형 인간이며 효율성과 성장을 중시합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      // ⚡️ 부지런하게 - 40대 회사원
      UserProfile(
        name: '정부지런',
        age: 42,
        job: '마케팅 매니저',
        hobbies: ['골프', '독서', '영어공부', '와인'],
        concept: RoutineConcept.diligent,
        additionalInfo: '규칙적이고 체계적인 생활을 좋아합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),

      // ☁️ 여유롭게 - 30대 요가강사
      UserProfile(
        name: '박여유',
        age: 35,
        job: '요가 강사',
        hobbies: ['요가', '명상', '산책', '독서'],
        concept: RoutineConcept.relaxed,
        additionalInfo: '느긋하고 평화로운 일상을 선호합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      // 🛋️ 쉬면서 살기 - 50대 프리랜서
      UserProfile(
        name: '유휴식',
        age: 53,
        job: '프리랜서 작가',
        hobbies: ['독서', '글쓰기', '영화감상', '반려동물 돌보기'],
        concept: RoutineConcept.restful,
        additionalInfo: '여유롭고 스트레스 없는 삶을 추구합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),

      // 🎨 크리에이티브 모드 - 20대 디자이너
      UserProfile(
        name: '이창작',
        age: 24,
        job: '그래픽 디자이너',
        hobbies: ['그림그리기', '사진촬영', '음악감상', '전시회 관람'],
        concept: RoutineConcept.creative,
        additionalInfo: '영감을 찾아 다양한 활동을 즐깁니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),

      // 🧠 미니멀 집중 - 30대 연구원
      UserProfile(
        name: '최집중',
        age: 31,
        job: '데이터 사이언티스트',
        hobbies: ['독서', '체스', '명상'],
        concept: RoutineConcept.minimal,
        additionalInfo: '핵심에만 집중하며 방해요소를 최소화합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),

      // 💼 워라밸 유지 - 20대 대학생
      UserProfile(
        name: '한균형',
        age: 22,
        job: '대학생',
        hobbies: ['게임', '영화감상', '친구만나기', '카페투어'],
        concept: RoutineConcept.workLifeBalance,
        additionalInfo: '공부와 휴식의 균형을 중요하게 생각합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),

      // 🐢 게으르지만 규칙적인 - 20대 학생
      UserProfile(
        name: '김느긋',
        age: 25,
        job: '대학원생',
        hobbies: ['넷플릭스', '웹툰', '배달음식', '낮잠'],
        concept: RoutineConcept.lazyButRegular,
        additionalInfo: '게으르지만 최소한의 루틴은 지키고 싶어요.',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),

      // 🧘‍♀️ 마음챙김 중심 - 30대 상담사
      UserProfile(
        name: '박마음',
        age: 34,
        job: '심리상담사',
        hobbies: ['명상', '요가', '감정일기', '자연관찰'],
        concept: RoutineConcept.mindfulness,
        additionalInfo: '내면의 평화와 감정 균형을 중시합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
      ),

      // 💪 피지컬 헬스 - 30대 트레이너
      UserProfile(
        name: '최건강',
        age: 32,
        job: '헬스 트레이너',
        hobbies: ['헬스', '등산', '수영', '요리'],
        concept: RoutineConcept.physicalHealth,
        additionalInfo: '신체 건강과 체력 향상이 최우선입니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),

      // 🛡️ 멘탈 회복용 - 20대 직장인
      UserProfile(
        name: '김회복',
        age: 26,
        job: '회사원',
        hobbies: ['산책', '음악감상', '간단한 요리', '반려식물 키우기'],
        concept: RoutineConcept.mentalRecovery,
        additionalInfo: '번아웃에서 회복 중이며 부담 없는 루틴을 원합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
      ),

      // 🎯 3일 도전 루틴 - 20대 취준생
      UserProfile(
        name: '도전왕',
        age: 24,
        job: '취업준비생',
        hobbies: ['독서', '운동', '자격증공부'],
        concept: RoutineConcept.challenge,
        additionalInfo: '작심삼일을 극복하고 싶어 3일 단위로 도전합니다.',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
  }

  static List<String> getCommonHobbies() {
    return [
      // 운동/건강
      '헬스', '요가', '필라테스', '등산', '수영', '러닝', '사이클링', '배드민턴', '테니스', '골프',
      
      // 문화/예술
      '독서', '영화감상', '음악감상', '그림그리기', '사진촬영', '글쓰기', '피아노', '기타', '노래',
      
      // 학습/자기계발
      '외국어공부', '온라인강의', '자격증공부', '블로그작성', '독서토론', '세미나참석',
      
      // 사회적 활동
      '친구만나기', '동호회활동', '봉사활동', '네트워킹', '파티참석', '미팅',
      
      // 취미/오락
      '게임', '요리', '베이킹', '가드닝', 'DIY', '퍼즐', '보드게임', '카드게임',
      
      // 여행/탐험
      '여행', '캠핑', '드라이브', '카페투어', '맛집탐방', '전시회관람', '콘서트관람',
      
      // 기타
      '반려동물돌보기', '명상', '산책', '쇼핑', '온라인쇼핑', '스트레칭', '일기쓰기',
    ];
  }

  static List<String> getCommonJobs() {
    return [
      // IT/기술
      '소프트웨어 개발자', '웹 개발자', 'iOS 개발자', '안드로이드 개발자', '데이터 사이언티스트', 
      'AI 엔지니어', '시스템 관리자', 'DevOps 엔지니어', 'QA 엔지니어', 'UI/UX 디자이너',
      
      // 디자인/크리에이티브
      '그래픽 디자이너', '웹 디자이너', '제품 디자이너', '패션 디자이너', '인테리어 디자이너',
      '광고 크리에이터', '영상 편집자', '사진작가', '일러스트레이터',
      
      // 비즈니스/경영
      '마케팅 매니저', '세일즈 매니저', '프로젝트 매니저', '인사담당자', '회계사', '재무 분석가',
      '컨설턴트', '기획자', '브랜드 매니저', 'PR 전문가',
      
      // 교육/연구
      '초등학교 교사', '중학교 교사', '고등학교 교사', '대학교 교수', '연구원', '학원강사',
      '온라인 강사', '교육컨텐츠 개발자',
      
      // 건강/의료
      '의사', '간호사', '약사', '물리치료사', '영양사', '헬스 트레이너', '요가 강사',
      '필라테스 강사', '스포츠 강사',
      
      // 서비스업
      '카페사장', '레스토랑 매니저', '호텔리어', '여행가이드', '뷰티샵 운영', '펜션 운영',
      
      // 기타
      '대학생', '대학원생', '취업준비생', '프리랜서', '자영업자', '주부', '은퇴자', '작가', '번역가',
    ];
  }

  static Map<String, List<String>> getJobHobbyRecommendations() {
    return {
      '개발자': ['코딩', '기술블로그', '오픈소스기여', '해커톤참여', '새로운언어공부'],
      '디자이너': ['그림그리기', '전시회관람', '디자인잡지구독', '폰트수집', '색감연구'],
      '마케터': ['트렌드분석', '광고분석', 'SNS운영', '브랜드연구', '소비자심리공부'],
      '교사': ['교육방법연구', '학생상담공부', '교육컨텐츠개발', '심리학공부', '독서'],
      '의료진': ['의학논문읽기', '건강관리', '요가', '명상', '의료봉사'],
      '트레이너': ['운동연구', '영양학공부', '새로운운동법연구', '헬스', '다이어트연구'],
      '학생': ['스터디그룹', '동아리활동', '인턴십', '자격증공부', '네트워킹'],
    };
  }
}