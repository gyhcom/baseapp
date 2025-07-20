import '../entities/user_usage.dart';

/// 사용자 이용량 관리 Repository 인터페이스
abstract class UsageRepository {
  /// 현재 사용량 정보 조회
  Future<UserUsage> getCurrentUsage();
  
  /// 사용량 정보 저장
  Future<void> saveUsage(UserUsage usage);
  
  /// AI 루틴 생성 시 사용량 증가
  Future<bool> consumeGeneration();
  
  /// 보너스 추가
  Future<void> addBonus(BonusType type, {String? description});
  
  /// 일일 사용량 리셋 (자정에 실행)
  Future<void> resetDailyUsage();
  
  /// 월간 사용량 리셋 (매월 1일에 실행)
  Future<void> resetMonthlyUsage();
  
  /// 프리미엄 구독 활성화
  Future<void> activatePremium({required DateTime expiryDate});
  
  /// 프리미엄 구독 해제
  Future<void> deactivatePremium();
  
  /// 사용 가능한 생성 횟수 확인
  Future<int> getAvailableGenerations();
  
  /// 생성 가능 여부 확인
  Future<bool> canGenerate();
  
  /// 사용량 히스토리 조회 (최근 30일)
  Future<List<UserUsage>> getUsageHistory({int days = 30});
  
  /// 보너스 히스토리 조회
  Future<List<BonusEarned>> getBonusHistory();
  
  /// 특정 타입의 보너스 오늘 획득 여부 확인
  Future<bool> hasBonusEarnedToday(BonusType type);
}