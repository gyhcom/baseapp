import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_usage.freezed.dart';
part 'user_usage.g.dart';

/// 사용자 이용량 추적 모델
@freezed
@HiveType(typeId: 4)
class UserUsage with _$UserUsage {
  const factory UserUsage({
    @HiveField(0) required String id,
    @HiveField(1) required DateTime date, // 날짜 (YYYY-MM-DD 기준)
    @HiveField(2) @Default(0) int dailyGenerations, // 일일 AI 생성 횟수
    @HiveField(3) @Default(0) int monthlyGenerations, // 월간 AI 생성 횟수
    @HiveField(4) @Default(0) int bonusGenerations, // 보너스 생성 횟수
    @HiveField(5) @Default(false) bool isPremium, // 프리미엄 사용자 여부
    @HiveField(6) DateTime? premiumExpiryDate, // 프리미엄 만료일
    @HiveField(7) @Default([]) List<BonusEarned> bonusHistory, // 보너스 획득 내역
    @HiveField(8) DateTime? lastResetDate, // 마지막 리셋 날짜
  }) = _UserUsage;

  factory UserUsage.fromJson(Map<String, dynamic> json) =>
      _$UserUsageFromJson(json);
}

/// 보너스 획득 타입
@freezed
@HiveType(typeId: 5)
class BonusEarned with _$BonusEarned {
  const factory BonusEarned({
    @HiveField(0) required String id,
    @HiveField(1) required BonusType type,
    @HiveField(2) required int amount, // 획득한 보너스 생성 횟수
    @HiveField(3) required DateTime earnedAt,
    @HiveField(4) @Default('') String description,
    @HiveField(5) @Default(false) bool isUsed, // 사용된 보너스인지
  }) = _BonusEarned;

  factory BonusEarned.fromJson(Map<String, dynamic> json) =>
      _$BonusEarnedFromJson(json);
}

/// 보너스 타입
@HiveType(typeId: 6)
enum BonusType {
  @HiveField(0)
  socialShare('소셜 공유', 1), // 루틴 공유 시 1개
  
  @HiveField(1)
  friendInvite('친구 초대', 2), // 친구 가입 시 2개
  
  @HiveField(2)
  streakAchievement('연속 달성', 1), // 7일 연속 완료 시 1개
  
  @HiveField(3)
  appReview('앱 리뷰', 1), // 앱스토어 리뷰 작성 시 1개
  
  @HiveField(4)
  welcomeBonus('가입 보너스', 5), // 신규 가입 시 5개
  
  @HiveField(5)
  specialEvent('특별 이벤트', 3); // 이벤트 보너스

  const BonusType(this.displayName, this.defaultAmount);
  
  final String displayName;
  final int defaultAmount;
}

/// 사용량 제한 정보
class UsageLimits {
  static const int dailyFreeGenerations = 3; // 일일 무료 생성 한도
  static const int monthlyFreeGenerations = 10; // 월간 무료 생성 한도
  static const int maxBonusGenerations = 20; // 최대 보너스 보유량
  
  // 프리미엄 혜택
  static const int premiumDailyLimit = 50; // 프리미엄 일일 한도 (사실상 무제한)
  static const int premiumMonthlyLimit = 1000; // 프리미엄 월간 한도
}

extension UserUsageX on UserUsage {
  /// 오늘 사용 가능한 총 생성 횟수
  int get availableGenerationsToday {
    if (isPremium && (premiumExpiryDate?.isAfter(DateTime.now()) ?? false)) {
      return UsageLimits.premiumDailyLimit - dailyGenerations;
    }
    
    final freeRemaining = UsageLimits.dailyFreeGenerations - dailyGenerations;
    final bonusRemaining = bonusGenerations;
    
    return (freeRemaining + bonusRemaining).clamp(0, double.infinity).toInt();
  }
  
  /// 이번 달 사용 가능한 총 생성 횟수
  int get availableGenerationsThisMonth {
    if (isPremium && (premiumExpiryDate?.isAfter(DateTime.now()) ?? false)) {
      return UsageLimits.premiumMonthlyLimit - monthlyGenerations;
    }
    
    final freeRemaining = UsageLimits.monthlyFreeGenerations - monthlyGenerations;
    final bonusRemaining = bonusGenerations;
    
    return (freeRemaining + bonusRemaining).clamp(0, double.infinity).toInt();
  }
  
  /// 무료 사용자인지 확인
  bool get isFreeUser {
    return !isPremium || (premiumExpiryDate?.isBefore(DateTime.now()) ?? true);
  }
  
  /// 오늘 생성 가능한지 확인
  bool get canGenerateToday {
    return availableGenerationsToday > 0;
  }
  
  /// 이번 달 생성 가능한지 확인
  bool get canGenerateThisMonth {
    return availableGenerationsThisMonth > 0;
  }
  
  /// 다음 리셋까지 남은 시간 (시간 단위)
  int get hoursUntilReset {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now).inHours;
  }
  
  /// 오늘 날짜인지 확인
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final usageDate = DateTime(date.year, date.month, date.day);
    return today.isAtSameMomentAs(usageDate);
  }
  
  /// 이번 달인지 확인
  bool get isThisMonth {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}