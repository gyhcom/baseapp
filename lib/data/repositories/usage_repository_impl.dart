import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/usage_repository.dart';
import '../../domain/entities/user_usage.dart';

/// 사용자 이용량 관리 Repository 구현체
class UsageRepositoryImpl implements UsageRepository {
  static const String _boxName = 'user_usage';
  static const String _currentUsageKey = 'current_usage';
  static const String _historyPrefix = 'usage_';
  
  final Uuid _uuid = const Uuid();
  
  Box<UserUsage>? _box;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    
    // Hive가 이미 초기화되었는지 확인
    if (!Hive.isBoxOpen(_boxName)) {
      // 어댑터가 등록되지 않았다면 등록
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(UserUsageAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(BonusEarnedAdapter());
      }
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(BonusTypeAdapter());
      }
    }
    
    _initialized = true;
  }

  Future<Box<UserUsage>> get box async {
    await _ensureInitialized();
    _box ??= await Hive.openBox<UserUsage>(_boxName);
    return _box!;
  }

  @override
  Future<UserUsage> getCurrentUsage() async {
    final box = await this.box;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    UserUsage? usage = box.get(_currentUsageKey);
    
    // 사용량 정보가 없거나 날짜가 다르면 새로 생성
    if (usage == null || !usage.isToday) {
      // 기존 사용량이 있으면 히스토리에 저장
      if (usage != null) {
        await _saveToHistory(usage);
      }
      
      // 새로운 사용량 생성
      usage = UserUsage(
        id: _uuid.v4(),
        date: today,
        dailyGenerations: 0,
        monthlyGenerations: usage?.isThisMonth == true ? usage!.monthlyGenerations : 0,
        bonusGenerations: usage?.bonusGenerations ?? 5, // 신규 사용자는 5개 보너스
        isPremium: usage?.isPremium ?? false,
        premiumExpiryDate: usage?.premiumExpiryDate,
        bonusHistory: usage?.bonusHistory ?? [],
        lastResetDate: today,
      );
      
      await saveUsage(usage);
    }
    
    return usage;
  }

  @override
  Future<void> saveUsage(UserUsage usage) async {
    final box = await this.box;
    await box.put(_currentUsageKey, usage);
  }

  @override
  Future<bool> consumeGeneration() async {
    final usage = await getCurrentUsage();
    
    if (!usage.canGenerateToday) {
      return false; // 생성 불가
    }
    
    // 보너스를 먼저 사용, 그 다음 일일 할당량 사용
    UserUsage updatedUsage;
    if (usage.bonusGenerations > 0) {
      updatedUsage = usage.copyWith(
        bonusGenerations: usage.bonusGenerations - 1,
      );
    } else {
      updatedUsage = usage.copyWith(
        dailyGenerations: usage.dailyGenerations + 1,
        monthlyGenerations: usage.monthlyGenerations + 1,
      );
    }
    
    await saveUsage(updatedUsage);
    return true; // 생성 성공
  }

  @override
  Future<void> addBonus(BonusType type, {String? description}) async {
    final usage = await getCurrentUsage();
    
    // 같은 타입의 보너스를 오늘 이미 받았는지 확인
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    final alreadyEarned = usage.bonusHistory.any((bonus) =>
        bonus.type == type &&
        bonus.earnedAt.isAfter(todayStart) &&
        bonus.earnedAt.isBefore(todayEnd));
        
    if (alreadyEarned && type != BonusType.specialEvent) {
      return; // 이미 오늘 받은 보너스 (특별 이벤트 제외)
    }
    
    final bonus = BonusEarned(
      id: _uuid.v4(),
      type: type,
      amount: type.defaultAmount,
      earnedAt: DateTime.now(),
      description: description ?? type.displayName,
    );
    
    final newBonusHistory = [...usage.bonusHistory, bonus];
    final newBonusAmount = (usage.bonusGenerations + type.defaultAmount)
        .clamp(0, UsageLimits.maxBonusGenerations);
    
    final updatedUsage = usage.copyWith(
      bonusGenerations: newBonusAmount,
      bonusHistory: newBonusHistory,
    );
    
    await saveUsage(updatedUsage);
  }

  @override
  Future<void> resetDailyUsage() async {
    final usage = await getCurrentUsage();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (usage.isToday) {
      return; // 이미 오늘 날짜임
    }
    
    // 어제 데이터를 히스토리에 저장
    await _saveToHistory(usage);
    
    // 새로운 일일 사용량으로 리셋
    final resetUsage = usage.copyWith(
      id: _uuid.v4(),
      date: today,
      dailyGenerations: 0,
      lastResetDate: today,
    );
    
    await saveUsage(resetUsage);
  }

  @override
  Future<void> resetMonthlyUsage() async {
    final usage = await getCurrentUsage();
    
    if (usage.isThisMonth) {
      return; // 이미 이번 달임
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // 월간 사용량 리셋
    final resetUsage = usage.copyWith(
      date: today,
      monthlyGenerations: 0,
      lastResetDate: today,
    );
    
    await saveUsage(resetUsage);
  }

  @override
  Future<void> activatePremium({required DateTime expiryDate}) async {
    final usage = await getCurrentUsage();
    
    final premiumUsage = usage.copyWith(
      isPremium: true,
      premiumExpiryDate: expiryDate,
    );
    
    await saveUsage(premiumUsage);
  }

  @override
  Future<void> deactivatePremium() async {
    final usage = await getCurrentUsage();
    
    final freeUsage = usage.copyWith(
      isPremium: false,
      premiumExpiryDate: null,
    );
    
    await saveUsage(freeUsage);
  }

  @override
  Future<int> getAvailableGenerations() async {
    final usage = await getCurrentUsage();
    return usage.availableGenerationsToday;
  }

  @override
  Future<bool> canGenerate() async {
    final usage = await getCurrentUsage();
    return usage.canGenerateToday;
  }

  @override
  Future<List<UserUsage>> getUsageHistory({int days = 30}) async {
    final box = await this.box;
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: days));
    
    final history = <UserUsage>[];
    
    // 현재 사용량도 포함
    final current = await getCurrentUsage();
    history.add(current);
    
    // 히스토리에서 최근 데이터 가져오기
    for (int i = 1; i <= days; i++) {
      final date = now.subtract(Duration(days: i));
      final key = _getHistoryKey(date);
      final usage = box.get(key);
      
      if (usage != null && usage.date.isAfter(cutoffDate)) {
        history.add(usage);
      }
    }
    
    // 날짜 내림차순 정렬
    history.sort((a, b) => b.date.compareTo(a.date));
    
    return history;
  }

  @override
  Future<List<BonusEarned>> getBonusHistory() async {
    final usage = await getCurrentUsage();
    
    // 최근 30일 내 보너스만 반환
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    
    return usage.bonusHistory
        .where((bonus) => bonus.earnedAt.isAfter(thirtyDaysAgo))
        .toList()
      ..sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
  }

  @override
  Future<bool> hasBonusEarnedToday(BonusType type) async {
    final usage = await getCurrentUsage();
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    return usage.bonusHistory.any((bonus) =>
        bonus.type == type &&
        bonus.earnedAt.isAfter(todayStart) &&
        bonus.earnedAt.isBefore(todayEnd));
  }

  /// 히스토리에 사용량 저장
  Future<void> _saveToHistory(UserUsage usage) async {
    final box = await this.box;
    final key = _getHistoryKey(usage.date);
    await box.put(key, usage);
  }

  /// 날짜별 히스토리 키 생성
  String _getHistoryKey(DateTime date) {
    return '$_historyPrefix${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}