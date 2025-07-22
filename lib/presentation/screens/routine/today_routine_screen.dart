import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../theme/app_theme.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/routine_item.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../di/service_locator.dart';
import '../../widgets/routine/routine_check_item.dart';
import '../../widgets/routine/progress_circle.dart';

/// 오늘의 루틴 실행 화면
/// 하루 일정을 체크리스트 형태로 보여주고 완료/미완료 체크 가능
@RoutePage()
class TodayRoutineScreen extends ConsumerStatefulWidget {
  final DailyRoutine routine;

  const TodayRoutineScreen({
    super.key,
    required this.routine,
  });

  @override
  ConsumerState<TodayRoutineScreen> createState() => _TodayRoutineScreenState();
}

class _TodayRoutineScreenState extends ConsumerState<TodayRoutineScreen>
    with TickerProviderStateMixin {
  late DailyRoutine _routine;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
    _setupAnimations();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    _updateProgress();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final completedCount = _routine.items.where((item) => item.isCompleted).length;
    final progress = _routine.items.isNotEmpty ? completedCount / _routine.items.length : 0.0;
    _progressController.animateTo(progress);
  }

  Future<void> _toggleItemComplete(RoutineItem item) async {
    try {
      final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
      final updatedItems = _routine.items.map((i) {
        return i.id == item.id ? updatedItem : i;
      }).toList();
      
      final updatedRoutine = _routine.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
      
      setState(() {
        _routine = updatedRoutine;
      });
      
      _updateProgress();
      
      // 루틴 저장
      final repository = getIt<RoutineRepository>();
      await repository.saveRoutine(updatedRoutine);
      
      // 완료 시 햅틱 피드백
      if (updatedItem.isCompleted) {
        // HapticFeedback.lightImpact();
      }
      
    } catch (e) {
      print('루틴 아이템 체크 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('체크 상태 변경에 실패했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int get _completedCount => _routine.items.where((item) => item.isCompleted).length;
  double get _progressPercent => _routine.items.isNotEmpty ? _completedCount / _routine.items.length : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 앱바 + 진행률
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: _routine.concept.color,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_outlined, color: Colors.white),
                tooltip: '홈으로',
                onPressed: () {
                  context.router.navigate(const HomeWrapperRoute());
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _routine.concept.color,
                      _routine.concept.color.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 40), // AppBar 높이 고려
                                    
                                    // 제목과 컨셉
                                    Text(
                                      '오늘의 루틴',
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    
                                    const SizedBox(height: AppTheme.spacingS),
                                    
                                    Text(
                                      _routine.concept.displayName,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // 진행률 표시
                                Padding(
                                  padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                                  child: Row(
                                    children: [
                                      AnimatedBuilder(
                                        animation: _progressAnimation,
                                        builder: (context, child) {
                                          return ProgressCircle(
                                            progress: _progressAnimation.value,
                                            size: 70,
                                            strokeWidth: 6,
                                            backgroundColor: Colors.white.withOpacity(0.3),
                                            progressColor: Colors.white,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${(_progressAnimation.value * 100).round()}%',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '$_completedCount/${_routine.items.length}',
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.8),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      
                                      const SizedBox(width: AppTheme.spacingL),
                                      
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '총 $_completedCount개 완료',
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            
                                            const SizedBox(height: AppTheme.spacingXS),
                                            
                                            Text(
                                              _progressPercent == 1.0 
                                                  ? '🎉 오늘 루틴을 모두 완료했어요!'
                                                  : '${_routine.items.length - _completedCount}개 남았어요',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 루틴 아이템 리스트
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _routine.items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                    child: RoutineCheckItem(
                      item: item,
                      onToggle: () => _toggleItemComplete(item),
                      onEdit: () => _editRoutineItem(item),
                      onDelete: () => _deleteRoutineItem(item),
                    ),
                  );
                },
                childCount: _routine.items.length,
              ),
            ),
          ),
          
          // 하단 여백
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
      
      // 플로팅 액션 버튼
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 새 아이템 추가
            FloatingActionButton(
              heroTag: "add_item",
              onPressed: _addNewItem,
              backgroundColor: _routine.concept.color,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            
            const SizedBox(height: 12),
            
            // 루틴 편집
            FloatingActionButton.small(
              heroTag: "edit_routine",
              onPressed: _editRoutine,
              backgroundColor: AppTheme.surfaceColor,
              child: Icon(Icons.edit, color: _routine.concept.color),
            ),
          ],
        ),
      ),
    );
  }

  void _editRoutineItem(RoutineItem item) {
    // TODO: 루틴 아이템 수정 다이얼로그
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 아이템 수정'),
        content: const Text('루틴 아이템 수정 기능을 구현 중입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _deleteRoutineItem(RoutineItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 아이템 삭제'),
        content: Text('${item.title}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performDeleteItem(item);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteItem(RoutineItem item) async {
    try {
      final updatedItems = _routine.items.where((i) => i.id != item.id).toList();
      final updatedRoutine = _routine.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
      
      setState(() {
        _routine = updatedRoutine;
      });
      
      _updateProgress();
      
      final repository = getIt<RoutineRepository>();
      await repository.saveRoutine(updatedRoutine);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.title}이(가) 삭제되었습니다'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('루틴 아이템 삭제 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('삭제에 실패했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addNewItem() {
    // TODO: 새 루틴 아이템 추가 다이얼로그
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 루틴 아이템 추가'),
        content: const Text('새 루틴 아이템 추가 기능을 구현 중입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _editRoutine() {
    // TODO: 전체 루틴 편집으로 이동
    context.router.maybePop();
  }
}