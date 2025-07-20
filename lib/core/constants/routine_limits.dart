/// 루틴 저장 및 생성 제한 상수
class RoutineLimits {
  // 루틴 저장 개수 제한
  static const int freeMaxRoutines = 5;      // 무료: 5개
  static const int premiumMaxRoutines = -1;  // 프리미엄: 무제한 (-1)
  
  // AI 생성 제한 (기존)
  static const int freeDailyGenerations = 3;
  static const int premiumDailyGenerations = -1;
  
  // 보너스 관련 제한
  static const int maxBonusGenerations = 10;
  
  // 경고 임계점
  static const int storageWarningThreshold = 4; // 4개부터 경고
}

/// 사용자 등급
enum UserTier {
  free,     // 무료 사용자
  premium,  // 프리미엄 사용자
}

/// 제한 타입
enum LimitType {
  routineStorage,    // 루틴 저장 개수
  dailyGeneration,   // 일일 AI 생성
}

/// 제한 상태
enum LimitStatus {
  available,    // 사용 가능
  warning,      // 경고 (임계점 근처)
  exceeded,     // 제한 초과
  unlimited,    // 무제한 (프리미엄)
}