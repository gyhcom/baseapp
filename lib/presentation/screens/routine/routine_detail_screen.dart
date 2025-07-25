import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/routine_item.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/services/routine_limit_service.dart';
import '../../../core/constants/routine_limits.dart';
import '../../../di/service_locator.dart';
import '../../widgets/routine/routine_item_card.dart';
import '../../providers/behavior_analytics_provider.dart';
import '../../../domain/entities/user_behavior_log.dart';

/// 루틴 상세 화면
class RoutineDetailScreen extends ConsumerStatefulWidget {
  final DailyRoutine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  ConsumerState<RoutineDetailScreen> createState() =>
      _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends ConsumerState<RoutineDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late DailyRoutine _currentRoutine;

  @override
  void initState() {
    super.initState();
    _currentRoutine = widget.routine;
    _initializeFadeAnimation();
  }

  void _initializeFadeAnimation() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleItemComplete(String itemId) async {
    // 루틴이 활성화되지 않은 경우 체크 방지
    if (!_currentRoutine.isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('📢 루틴을 활성화해주세요! 활성화 후 루틴을 완료할 수 있습니다.'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: '활성화',
            textColor: Colors.white,
            onPressed: () {
              _toggleActiveStatus();
            },
          ),
        ),
      );
      return; // 체크 동작 중단
    }

    final behaviorLogger = ref.read(behaviorLoggerProvider);
    final userId = 'current_user'; // 실제로는 현재 로그인된 사용자 ID 사용

    setState(() {
      final updatedItems = _currentRoutine.items.map((item) {
        if (item.id == itemId) {
          final wasCompleted = item.isCompleted;
          final newCompleted = !item.isCompleted;

          // 로그 수집 (비동기로 실행)
          if (newCompleted && !wasCompleted) {
            // 완료로 변경될 때
            behaviorLogger.logRoutineCompleted(
              userId: userId,
              routineId: _currentRoutine.id,
              routineItemId: itemId,
            );
            print('🎉 루틴 아이템 완료: ${item.title}');
          } else if (!newCompleted && wasCompleted) {
            // 완료 취소될 때
            behaviorLogger.quickLog(
              userId: userId,
              routineId: _currentRoutine.id,
              type: BehaviorType.routineStarted, // 다시 시작으로 간주
            );
            print('🔄 루틴 아이템 완료 취소: ${item.title}');
          }

          return item.copyWith(isCompleted: newCompleted);
        }
        return item;
      }).toList();

      _currentRoutine = _currentRoutine.copyWith(items: updatedItems);
    });

    // 전체 루틴 완료 체크
    final completedCount = _currentRoutine.items
        .where((item) => item.isCompleted)
        .length;
    final totalCount = _currentRoutine.items.length;

    if (completedCount == totalCount && totalCount > 0) {
      // 모든 항목 완료 시 전체 루틴 완료 로그
      await behaviorLogger.logRoutineCompleted(
        userId: userId,
        routineId: _currentRoutine.id,
        routineItemId: 'full_routine',
        duration: const Duration(minutes: 30), // 대략적인 소요 시간
      );

      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🎉 루틴을 모두 완료했어요! 멋져요!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      print('🏆 전체 루틴 완료! 사용 횟수 증가');

      // 사용 횟수 증가 및 루틴 업데이트
      try {
        final routineRepository = getIt<RoutineRepository>();
        await routineRepository.incrementUsageCount(_currentRoutine.id);

        // 변경된 루틴 상태를 데이터베이스에 저장
        await routineRepository.updateRoutine(_currentRoutine);
        print('✅ 루틴 상태 저장 완료');
      } catch (e) {
        print('❌ 루틴 업데이트 실패: $e');
      }
    } else {
      // 전체 완료가 아니더라도 개별 항목 변경사항은 저장
      try {
        final routineRepository = getIt<RoutineRepository>();
        await routineRepository.updateRoutine(_currentRoutine);
        print('✅ 루틴 항목 변경사항 저장');
      } catch (e) {
        print('❌ 루틴 항목 업데이트 실패: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_currentRoutine.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: '홈으로',
            onPressed: () {
              context.router.navigate(const HomeWrapperRoute());
            },
          ),
          IconButton(
            icon: Icon(
              _currentRoutine.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _currentRoutine.isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(icon: const Icon(Icons.share), onPressed: _shareRoutine),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // 루틴 헤더 정보 (진행률 포함)
            _buildRoutineHeader(),

            // 루틴 아이템 목록
            Expanded(child: _buildRoutineItemsList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _customizeRoutine,
        icon: const Icon(Icons.edit),
        label: const Text('루틴 수정'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildRoutineHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), // 하단 마진 줄임
      padding: const EdgeInsets.all(16), // 패딩 줄임
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradientDecoration,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        children: [
          // 컨셉 이모지 (크기 줄임)
          Container(
            width: 48, // 60에서 48로 줄임
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _currentRoutine.concept.displayName.split(' ')[0],
                style: const TextStyle(fontSize: 24), // 30에서 24로 줄임
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 루틴 정보 (컴팩트하게)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // 최소 크기로
              children: [
                // 제목과 활성화 토글을 한 줄에
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _currentRoutine.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              // titleLarge에서 titleMedium으로
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 활성화 스위치를 제목 옆으로 이동
                    Transform.scale(
                      scale: 0.8, // 스위치 크기 줄임
                      child: Switch(
                        key: ValueKey(_currentRoutine.isActive),
                        value: _currentRoutine.isActive,
                        onChanged: (value) {
                          _toggleActiveStatus();
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.white.withOpacity(0.3),
                        inactiveThumbColor: Colors.white.withOpacity(0.5),
                        inactiveTrackColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // 컨셉과 진행률 정보를 한 줄에
                Row(
                  children: [
                    Text(
                      _currentRoutine.concept.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 진행률 표시 추가
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white.withOpacity(0.9),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_currentRoutine.items.where((item) => item.isCompleted).length}/${_currentRoutine.items.length}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _currentRoutine.isActive
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: Colors.white.withOpacity(0.7),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentRoutine.isActive ? '활성' : '비활성',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineItemsList() {
    // 시간대별로 그룹화
    final groupedItems = _groupItemsByTimeOfDay();

    return Column(
      children: [
        // 비활성화 상태 안내 메시지
        if (!_currentRoutine.isActive)
          Container(
            margin: const EdgeInsets.all(AppTheme.spacingL),
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: AppTheme.mediumRadius,
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 24),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '루틴이 비활성화되어 있어요',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '활성화 후 루틴을 완료할 수 있습니다',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // 루틴 아이템 리스트
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            itemCount: groupedItems.length,
            itemBuilder: (context, index) {
              final group = groupedItems[index];
              return _buildTimeGroup(group);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeGroup(Map<String, dynamic> group) {
    final timeLabel = group['label'] as String;
    final items = group['items'] as List<RoutineItem>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 시간대 라벨
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                timeLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // 해당 시간대 아이템들
        ...items
            .map(
              (item) => RoutineItemCard(
                item: item,
                onToggleComplete: () => _toggleItemComplete(item.id),
                onEdit: () => _editItem(item),
                isEnabled: _currentRoutine.isActive, // 루틴 활성화 상태 전달
              ),
            )
            .toList(),

        const SizedBox(height: AppTheme.spacingL),
      ],
    );
  }

  List<Map<String, dynamic>> _groupItemsByTimeOfDay() {
    final groups = <String, List<RoutineItem>>{
      '🌅 새벽 (05:00 - 07:59)': [],
      '🌞 오전 (08:00 - 11:59)': [],
      '☀️ 점심 (12:00 - 13:59)': [],
      '🌤️ 오후 (14:00 - 17:59)': [],
      '🌆 저녁 (18:00 - 20:59)': [],
      '🌙 밤 (21:00 - 23:59)': [],
      '🌃 심야 (00:00 - 04:59)': [],
    };

    for (final item in _currentRoutine.items) {
      final hour = item.startTime.hour;

      if (hour >= 5 && hour < 8) {
        groups['🌅 새벽 (05:00 - 07:59)']!.add(item);
      } else if (hour >= 8 && hour < 12) {
        groups['🌞 오전 (08:00 - 11:59)']!.add(item);
      } else if (hour >= 12 && hour < 14) {
        groups['☀️ 점심 (12:00 - 13:59)']!.add(item);
      } else if (hour >= 14 && hour < 18) {
        groups['🌤️ 오후 (14:00 - 17:59)']!.add(item);
      } else if (hour >= 18 && hour < 21) {
        groups['🌆 저녁 (18:00 - 20:59)']!.add(item);
      } else if (hour >= 21 && hour < 24) {
        groups['🌙 밤 (21:00 - 23:59)']!.add(item);
      } else {
        groups['🌃 심야 (00:00 - 04:59)']!.add(item);
      }
    }

    // 빈 그룹 제거하고 시간순으로 정렬
    return groups.entries.where((entry) => entry.value.isNotEmpty).map((entry) {
      // 각 그룹 내에서 시간순 정렬
      entry.value.sort((a, b) {
        final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
        final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
        return aMinutes.compareTo(bMinutes);
      });

      return {'label': entry.key, 'items': entry.value};
    }).toList();
  }

  String _formatTotalDuration() {
    final totalMinutes = _currentRoutine.items.fold<int>(
      0,
      (sum, item) => sum + item.duration.inMinutes,
    );

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  void _toggleFavorite() {
    setState(() {
      _currentRoutine = _currentRoutine.copyWith(
        isFavorite: !_currentRoutine.isFavorite,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentRoutine.isFavorite ? '즐겨찾기에 추가되었습니다' : '즐겨찾기에서 제거되었습니다',
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _shareRoutine() {
    final StringBuffer shareText = StringBuffer();
    shareText.writeln('📅 ${widget.routine.title}');
    shareText.writeln('');
    shareText.writeln('🎯 컨셉: ${widget.routine.concept.displayName}');

    if (widget.routine.description.isNotEmpty) {
      shareText.writeln('💭 설명: ${widget.routine.description}');
    }

    shareText.writeln('');
    shareText.writeln('⏰ 하루 루틴:');

    // 시간대별로 루틴 아이템 그룹화
    final Map<String, List<RoutineItem>> groupedItems = {};

    for (final item in widget.routine.items) {
      final hour = item.startTime.hour;
      String timeCategory;

      if (hour < 6) {
        timeCategory = '🌙 새벽 (00:00-05:59)';
      } else if (hour < 12) {
        timeCategory = '🌅 오전 (06:00-11:59)';
      } else if (hour < 18) {
        timeCategory = '☀️ 오후 (12:00-17:59)';
      } else {
        timeCategory = '🌆 저녁 (18:00-23:59)';
      }

      groupedItems.putIfAbsent(timeCategory, () => []);
      groupedItems[timeCategory]!.add(item);
    }

    // 시간대별로 정렬된 루틴 아이템 출력
    for (final entry in groupedItems.entries) {
      shareText.writeln('');
      shareText.writeln(entry.key);

      for (final item in entry.value) {
        final startTime = item.timeDisplay;
        shareText.writeln(
          '  • $startTime ${item.title} (${item.durationDisplay})',
        );
      }
    }

    shareText.writeln('');
    shareText.writeln('📱 RoutineCraft로 만든 개인 맞춤 루틴입니다!');
    shareText.writeln('🔗 앱에서 나만의 루틴을 만들어보세요');

    Share.share(
      shareText.toString(),
      subject: '${widget.routine.title} - 나의 하루 루틴',
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('루틴 복사'),
              onTap: () {
                Navigator.pop(context);
                _copyRoutine();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('루틴 수정'),
              onTap: () {
                Navigator.pop(context);
                _customizeRoutine();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('루틴 삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteRoutine();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _customizeRoutine() {
    // TODO: 루틴 커스터마이징 화면으로 이동
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('루틴 수정 기능은 준비 중입니다')));
  }

  void _editItem(RoutineItem item) {
    // TODO: 개별 아이템 수정 기능
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.title} 수정 기능은 준비 중입니다')));
  }

  Future<void> _copyRoutine() async {
    try {
      // 로딩 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Text('루틴 복사 중...'),
              ],
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }

      final routineRepository = getIt<RoutineRepository>();

      // 저장 제한 체크
      final currentCount = await routineRepository.getSavedRoutines();
      if (currentCount.length >= 2) {
        // 무료 사용자 제한
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '무료 사용자는 2개의 루틴만 저장할 수 있습니다. 기존 루틴을 삭제하거나 프리미엄으로 업그레이드하세요',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // 새로운 ID와 제목으로 복사본 생성
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final copiedRoutine = widget.routine.copyWith(
        id: timestamp,
        title: '${widget.routine.title} (복사본)',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        usageCount: 0,
        isFavorite: false,
        // 루틴 아이템들도 새로운 ID로 복사
        items: widget.routine.items
            .map(
              (item) => item.copyWith(
                id: '${timestamp}_${item.id}',
                isCompleted: false, // 복사본은 완료되지 않은 상태로
              ),
            )
            .toList(),
      );

      // 복사본 저장
      await routineRepository.saveRoutine(copiedRoutine);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 루틴이 성공적으로 복사되었습니다'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 루틴 복사에 실패했어요: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _deleteRoutine() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 삭제'),
        content: const Text('이 루틴을 삭제하시겠습니까?\n삭제된 루틴은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.router.maybePop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('루틴이 삭제되었습니다'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 루틴 활성화 상태 토글
  Future<void> _toggleActiveStatus() async {
    print('🔄 루틴 활성화 토글 시작: ${_currentRoutine.title} (현재: ${_currentRoutine.isActive})');

    try {
      final routineRepository = getIt<RoutineRepository>();
      final targetState = !_currentRoutine.isActive;

      // 활성화하려는 경우 제한 검사
      if (targetState) {
        print('📊 활성화 제한 검사 중...');
        final canActivate = await RoutineLimitService.canActivateRoutine();
        print('📊 활성화 가능 여부: $canActivate');

        if (!canActivate) {
          print('❌ 활성화 제한으로 인해 실패');
          _showActivationLimitDialog();
          return;
        }

        // 무료 사용자는 기존 활성화된 루틴을 자동 비활성화
        final userTier = await RoutineLimitService.getUserTier();
        print('👤 사용자 등급: $userTier');
        if (userTier == UserTier.free) {
          print('🔧 기존 활성화된 루틴들 비활성화 중...');
          await routineRepository.deactivateAllRoutines(exceptRoutineId: _currentRoutine.id);
        }
      }

      // 데이터베이스 상태 업데이트 (토글 대신 명시적 설정)
      print('🔧 데이터베이스에서 루틴 상태 변경: ${_currentRoutine.isActive} → $targetState');
      final routineToUpdate = _currentRoutine.copyWith(isActive: targetState);
      await routineRepository.updateRoutine(routineToUpdate);

      // 변경된 데이터를 다시 가져와서 확인
      final updatedRoutine = await routineRepository.getRoutineById(_currentRoutine.id);
      
      if (updatedRoutine != null) {
        print('📊 DB에서 가져온 실제 상태: ${updatedRoutine.isActive}');
        
        // UI 상태 업데이트 (DB 상태를 신뢰)
        setState(() {
          _currentRoutine = updatedRoutine;
        });
        
        // 행동 로그 수집
        final behaviorLogger = ref.read(behaviorLoggerProvider);
        const userId = 'current_user';

        if (_currentRoutine.isActive) {
          await behaviorLogger.quickLog(
            userId: userId,
            routineId: _currentRoutine.id,
            type: BehaviorType.routineStarted,
          );
          print('📊 루틴 활성화 로그 기록');
        }

        // 성공 메시지
        final message = _currentRoutine.isActive
            ? '✅ 루틴이 활성화되었습니다'
            : '⏸️ 루틴이 비활성화되었습니다';

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: _currentRoutine.isActive ? Colors.green : Colors.grey,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        
        print('✅ 루틴 상태 변경 완료: ${_currentRoutine.isActive}');
      } else {
        throw Exception('업데이트된 루틴 정보를 가져올 수 없습니다');
      }
    } catch (e) {
      print('❌ 루틴 활성화 토글 실패: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('상태 변경에 실패했습니다: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 활성화 제한 다이얼로그 표시
  void _showActivationLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔒 활성화 제한'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '무료 사용자는 1개의 루틴만 활성화할 수 있습니다.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              '프리미엄으로 업그레이드하면:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('✨ 무제한 루틴 활성화'),
            Text('✨ 무제한 루틴 저장'),
            Text('✨ 루틴당 최대 10개 활동'),
            Text('✨ 무제한 AI 루틴 생성'),
            Text('✨ 통계 및 분석 기능'),
            Text('✨ 백업 및 복원'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPremiumUpgradeInfo();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text(
              '프리미엄 알아보기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// 프리미엄 업그레이드 정보 표시
  void _showPremiumUpgradeInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚧 프리미엄 기능은 준비 중입니다. 곧 출시될 예정입니다!'),
        backgroundColor: AppTheme.primaryColor,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
