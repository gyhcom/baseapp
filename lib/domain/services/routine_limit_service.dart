import '../repositories/routine_repository.dart';
import '../repositories/usage_repository.dart';
import '../../core/constants/routine_limits.dart';
import '../../di/service_locator.dart';

/// 루틴 저장 제한 관리 서비스
class RoutineLimitService {
  static RoutineRepository get _routineRepo => getIt<RoutineRepository>();
  static UsageRepository get _usageRepo => getIt<UsageRepository>();

  /// 새 루틴 저장 가능 여부 확인
  static Future<bool> canSaveNewRoutine() async {
    final usage = await _usageRepo.getCurrentUsage();
    
    // 프리미엄 사용자는 무제한
    if (await _isPremiumUser(usage)) {
      return true;
    }
    
    // 무료 사용자는 5개 제한
    final currentRoutines = await _routineRepo.getSavedRoutines();
    return currentRoutines.length < RoutineLimits.freeMaxRoutines;
  }

  /// 저장 가능한 루틴 개수 확인
  static Future<int> getRemainingSlots() async {
    final usage = await _usageRepo.getCurrentUsage();
    
    // 프리미엄 사용자는 무제한
    if (await _isPremiumUser(usage)) {
      return -1; // 무제한 표시
    }
    
    final currentRoutines = await _routineRepo.getSavedRoutines();
    return (RoutineLimits.freeMaxRoutines - currentRoutines.length).clamp(0, RoutineLimits.freeMaxRoutines);
  }

  /// 현재 저장된 루틴 개수
  static Future<int> getCurrentRoutineCount() async {
    final routines = await _routineRepo.getSavedRoutines();
    return routines.length;
  }

  /// 저장 공간 상태 확인
  static Future<LimitStatus> getStorageStatus() async {
    final usage = await _usageRepo.getCurrentUsage();
    
    // 프리미엄 사용자는 무제한
    if (await _isPremiumUser(usage)) {
      return LimitStatus.unlimited;
    }
    
    final currentCount = await getCurrentRoutineCount();
    
    if (currentCount >= RoutineLimits.freeMaxRoutines) {
      return LimitStatus.exceeded;
    } else if (currentCount >= RoutineLimits.storageWarningThreshold) {
      return LimitStatus.warning;
    } else {
      return LimitStatus.available;
    }
  }

  /// 사용자 등급 확인
  static Future<UserTier> getUserTier() async {
    final usage = await _usageRepo.getCurrentUsage();
    return await _isPremiumUser(usage) ? UserTier.premium : UserTier.free;
  }

  /// 저장 공간 사용률 (0.0 ~ 1.0)
  static Future<double> getStorageUsageRatio() async {
    final usage = await _usageRepo.getCurrentUsage();
    
    // 프리미엄 사용자는 사용률 계산 안함
    if (await _isPremiumUser(usage)) {
      return 0.0;
    }
    
    final currentCount = await getCurrentRoutineCount();
    return currentCount / RoutineLimits.freeMaxRoutines;
  }

  /// 루틴 삭제 후 슬롯 확보 안내 메시지
  static Future<String> getDeletionSuggestionMessage() async {
    final currentCount = await getCurrentRoutineCount();
    final usage = await _usageRepo.getCurrentUsage();
    
    if (await _isPremiumUser(usage)) {
      return '프리미엄 사용자는 무제한으로 루틴을 저장할 수 있습니다.';
    }
    
    if (currentCount >= RoutineLimits.freeMaxRoutines) {
      return '새 루틴을 저장하려면 기존 루틴 중 ${currentCount - RoutineLimits.freeMaxRoutines + 1}개를 삭제해주세요.';
    }
    
    return '${RoutineLimits.freeMaxRoutines - currentCount}개의 루틴을 더 저장할 수 있습니다.';
  }

  /// 프리미엄 사용자 여부 확인 (내부 헬퍼 메서드)
  static Future<bool> _isPremiumUser(dynamic usage) async {
    return usage.isPremium && 
           (usage.premiumExpiryDate?.isAfter(DateTime.now()) ?? false);
  }

  /// 루틴 저장 시 제한 검사 및 처리
  static Future<RoutineSaveResult> validateAndPrepareForSave() async {
    final canSave = await canSaveNewRoutine();
    final status = await getStorageStatus();
    final remainingSlots = await getRemainingSlots();
    final currentCount = await getCurrentRoutineCount();
    
    return RoutineSaveResult(
      canSave: canSave,
      status: status,
      remainingSlots: remainingSlots,
      currentCount: currentCount,
      maxCount: RoutineLimits.freeMaxRoutines,
    );
  }
}

/// 루틴 저장 결과 정보
class RoutineSaveResult {
  final bool canSave;
  final LimitStatus status;
  final int remainingSlots;
  final int currentCount;
  final int maxCount;

  const RoutineSaveResult({
    required this.canSave,
    required this.status,
    required this.remainingSlots,
    required this.currentCount,
    required this.maxCount,
  });

  /// 경고 메시지 생성
  String get warningMessage {
    switch (status) {
      case LimitStatus.exceeded:
        return '저장 공간이 부족합니다. ($currentCount/$maxCount)';
      case LimitStatus.warning:
        return '저장 공간이 거의 찼습니다. ($currentCount/$maxCount)';
      case LimitStatus.available:
        return '$remainingSlots개의 루틴을 더 저장할 수 있습니다.';
      case LimitStatus.unlimited:
        return '프리미엄: 무제한 저장 가능';
    }
  }

  /// 사용률 (0.0 ~ 1.0)
  double get usageRatio {
    if (status == LimitStatus.unlimited) return 0.0;
    return currentCount / maxCount;
  }
}