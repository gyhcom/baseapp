import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../theme/app_theme.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/routine_concept.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/services/routine_limit_service.dart';
import '../../../core/constants/routine_limits.dart';
import '../../../di/service_locator.dart';
import '../../widgets/routine/routine_summary_card.dart';
import 'routine_detail_screen.dart';
import 'user_input_screen.dart';

/// 내 루틴 목록 화면
class MyRoutinesScreen extends StatefulWidget {
  const MyRoutinesScreen({super.key});

  @override
  State<MyRoutinesScreen> createState() => _MyRoutinesScreenState();
}

class _MyRoutinesScreenState extends State<MyRoutinesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final RoutineRepository _routineRepository = getIt<RoutineRepository>();
  final TextEditingController _searchController = TextEditingController();
  
  List<DailyRoutine> _allRoutines = [];
  List<DailyRoutine> _favoriteRoutines = [];
  List<DailyRoutine> _filteredAllRoutines = [];
  List<DailyRoutine> _filteredFavoriteRoutines = [];
  bool _isLoading = true;
  bool _isSearching = false;
  
  // 필터링 상태
  String _searchQuery = '';
  Set<RoutineConcept> _selectedConcepts = {};
  
  // 저장 공간 관련 상태
  int _currentCount = 0;
  int _remainingSlots = 0;
  LimitStatus _storageStatus = LimitStatus.available;
  UserTier _userTier = UserTier.free;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRoutines();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutines() async {
    setState(() => _isLoading = true);

    try {
      final allRoutines = await _routineRepository.getSavedRoutines();
      final favoriteRoutines = await _routineRepository.getFavoriteRoutines();
      
      // 저장 공간 정보 로드
      final currentCount = await RoutineLimitService.getCurrentRoutineCount();
      final remainingSlots = await RoutineLimitService.getRemainingSlots();
      final storageStatus = await RoutineLimitService.getStorageStatus();
      final userTier = await RoutineLimitService.getUserTier();

      setState(() {
        _allRoutines = allRoutines;
        _favoriteRoutines = favoriteRoutines;
        _filteredAllRoutines = allRoutines;
        _filteredFavoriteRoutines = favoriteRoutines;
        _currentCount = currentCount;
        _remainingSlots = remainingSlots;
        _storageStatus = storageStatus;
        _userTier = userTier;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ToastUtils.showWithIcon(
          message: '루틴 목록을 불러오는데 실패했어요',
          icon: Icons.error_outline,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('내 루틴'),
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
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewRoutine,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
        bottom: _isSearching ? null : TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: '전체 (${_filteredAllRoutines.length})',
              icon: const Icon(Icons.list),
            ),
            Tab(
              text: '즐겨찾기 (${_filteredFavoriteRoutines.length})',
              icon: const Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingWidget()
          : Column(
              children: [
                // 검색 바 (검색 모드일 때만)
                if (_isSearching) _buildSearchBar(),
                // 필터 칩들
                _buildFilterChips(),
                // 저장 공간 표시 위젯
                _buildStorageIndicator(),
                // 탭뷰 또는 검색 결과
                Expanded(
                  child: _isSearching
                      ? _buildSearchResults()
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAllRoutinesTab(),
                            _buildFavoriteRoutinesTab(),
                          ],
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewRoutine,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppTheme.spacingM),
          Text('루틴 목록을 불러오는 중...'),
        ],
      ),
    );
  }

  Widget _buildAllRoutinesTab() {
    if (_filteredAllRoutines.isEmpty) {
      if (_searchQuery.isNotEmpty || _selectedConcepts.isNotEmpty) {
        return _buildEmptyState(
          icon: Icons.search_off,
          title: '검색 결과가 없어요',
          subtitle: '다른 검색어나 필터를 시도해보세요',
          buttonText: '필터 초기화',
          onButtonPressed: _clearFilters,
        );
      }
      return _buildEmptyState(
        icon: Icons.event_note,
        title: '아직 생성된 루틴이 없어요',
        subtitle: '새로운 루틴을 생성해보세요!',
        buttonText: '루틴 생성하기',
        onButtonPressed: _createNewRoutine,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRoutines,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        itemCount: _filteredAllRoutines.length,
        itemBuilder: (context, index) {
          final routine = _filteredAllRoutines[index];
          return RoutineSummaryCard(
            routine: routine,
            onTap: () => _openRoutineDetail(routine),
            onFavoriteToggle: () => _toggleFavorite(routine.id),
            onDelete: () => _deleteRoutine(routine.id),
            onCopy: () => _loadRoutines(),
            onActiveToggle: () => _loadRoutines(),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteRoutinesTab() {
    if (_filteredFavoriteRoutines.isEmpty) {
      if (_searchQuery.isNotEmpty || _selectedConcepts.isNotEmpty) {
        return _buildEmptyState(
          icon: Icons.search_off,
          title: '검색 결과가 없어요',
          subtitle: '다른 검색어나 필터를 시도해보세요',
          buttonText: '필터 초기화',
          onButtonPressed: _clearFilters,
        );
      }
      return _buildEmptyState(
        icon: Icons.favorite_border,
        title: '즐겨찾기한 루틴이 없어요',
        subtitle: '마음에 드는 루틴을 즐겨찾기로 추가해보세요',
        buttonText: '루틴 둘러보기',
        onButtonPressed: () => _tabController.animateTo(0),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRoutines,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        itemCount: _filteredFavoriteRoutines.length,
        itemBuilder: (context, index) {
          final routine = _filteredFavoriteRoutines[index];
          return RoutineSummaryCard(
            routine: routine,
            onTap: () => _openRoutineDetail(routine),
            onFavoriteToggle: () => _toggleFavorite(routine.id),
            onDelete: () => _deleteRoutine(routine.id),
            onCopy: () => _loadRoutines(),
            onActiveToggle: () => _loadRoutines(),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                size: 50,
                color: AppTheme.primaryColor,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacingS),
            
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppTheme.spacingXL),
            
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  void _openRoutineDetail(DailyRoutine routine) {
    // 사용 횟수 증가
    _routineRepository.incrementUsageCount(routine.id);
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineDetailScreen(routine: routine),
      ),
    ).then((_) {
      // 상세 화면에서 돌아올 때 목록 새로고침
      _loadRoutines();
    });
  }

  Future<void> _toggleFavorite(String routineId) async {
    try {
      await _routineRepository.toggleFavorite(routineId);
      await _loadRoutines(); // 목록 새로고침
      
      // 즐겨찾기는 하트 아이콘 변화만으로도 충분한 피드백
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('즐겨찾기가 변경되었습니다'),
      //     duration: Duration(seconds: 1),
      //   ),
      // );
    } catch (e) {
      ToastUtils.showWithIcon(
        message: '즐겨찾기 변경에 실패했어요',
        icon: Icons.error_outline,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _deleteRoutine(String routineId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 삭제'),
        content: const Text('이 루틴을 삭제하시겠습니까?\n삭제된 루틴은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _routineRepository.deleteRoutine(routineId);
        await _loadRoutines(); // 목록 새로고침
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('루틴이 삭제되었습니다'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('루틴 삭제에 실패했어요: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _createNewRoutine() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UserInputScreen(),
      ),
    ).then((_) {
      // 루틴 생성 화면에서 돌아올 때 목록 새로고침
      _loadRoutines();
    });
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
              leading: const Icon(Icons.refresh),
              title: const Text('목록 새로고침'),
              onTap: () {
                Navigator.pop(context);
                _loadRoutines();
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text('정렬 옵션'),
              onTap: () {
                Navigator.pop(context);
                _showSortOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('전체 삭제'),
              onTap: () {
                Navigator.pop(context);
                _clearAllRoutines();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('정렬 옵션'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('최신순'),
              leading: Radio<String>(
                value: 'latest',
                groupValue: 'latest', // TODO: 실제 정렬 상태 연결
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
            ListTile(
              title: const Text('사용 횟수순'),
              leading: Radio<String>(
                value: 'usage',
                groupValue: 'latest',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
            ListTile(
              title: const Text('즐겨찾기순'),
              leading: Radio<String>(
                value: 'favorite',
                groupValue: 'latest',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllRoutines() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 삭제'),
        content: const Text('모든 루틴을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('전체 삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _routineRepository.clearAllData();
        await _loadRoutines();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('모든 루틴이 삭제되었습니다'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('삭제에 실패했어요: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// 저장 공간 인디케이터 위젯
  Widget _buildStorageIndicator() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
        border: Border.all(
          color: _getStorageStatusColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Icon(
                _getStorageStatusIcon(),
                color: _getStorageStatusColor(),
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '저장 공간',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildTierBadge(),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // 프로그레스 바
          _buildProgressBar(),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // 상태 메시지
          _buildStatusMessage(),
        ],
      ),
    );
  }

  /// 사용자 등급 배지
  Widget _buildTierBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _userTier == UserTier.premium 
            ? Colors.amber.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _userTier == UserTier.premium 
              ? Colors.amber
              : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _userTier == UserTier.premium ? Icons.star : Icons.person,
            size: 12,
            color: _userTier == UserTier.premium ? Colors.amber : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            _userTier == UserTier.premium ? '프리미엄' : '무료',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _userTier == UserTier.premium ? Colors.amber.shade700 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// 프로그레스 바
  Widget _buildProgressBar() {
    if (_userTier == UserTier.premium) {
      return Container(
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            colors: [Colors.amber.shade300, Colors.amber.shade500],
          ),
        ),
        child: const Center(
          child: Text(
            '무제한',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final progress = _currentCount / RoutineLimits.freeMaxRoutines;
    
    return Column(
      children: [
        Stack(
          children: [
            // 배경
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // 진행률
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: _getStorageStatusColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_currentCount/${RoutineLimits.freeMaxRoutines} 사용',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStorageStatusColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 상태 메시지
  Widget _buildStatusMessage() {
    String message;
    Color messageColor;
    IconData messageIcon;

    switch (_storageStatus) {
      case LimitStatus.available:
        message = '${_remainingSlots}개의 루틴을 더 저장할 수 있어요';
        messageColor = Colors.blue;
        messageIcon = Icons.info_outline;
        break;
      case LimitStatus.warning:
        message = '저장 공간이 거의 찼어요. 프리미엄으로 업그레이드하면 무제한 저장 가능해요';
        messageColor = Colors.orange;
        messageIcon = Icons.warning_amber;
        break;
      case LimitStatus.exceeded:
        message = '저장 공간이 가득 찼어요. 기존 루틴을 삭제하거나 프리미엄으로 업그레이드하세요';
        messageColor = Colors.red;
        messageIcon = Icons.error_outline;
        break;
      case LimitStatus.unlimited:
        message = '프리미엄 사용자로 무제한 저장이 가능해요';
        messageColor = Colors.amber;
        messageIcon = Icons.star;
        break;
    }

    return Row(
      children: [
        Icon(
          messageIcon,
          size: 16,
          color: messageColor,
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: messageColor,
            ),
          ),
        ),
        if (_storageStatus == LimitStatus.warning || _storageStatus == LimitStatus.exceeded) ...[ 
          const SizedBox(width: AppTheme.spacingS),
          TextButton(
            onPressed: _showPremiumUpgradeDialog,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '업그레이드',
              style: TextStyle(
                fontSize: 12,
                color: messageColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// 저장 상태에 따른 색상
  Color _getStorageStatusColor() {
    switch (_storageStatus) {
      case LimitStatus.available:
        return Colors.blue;
      case LimitStatus.warning:
        return Colors.orange;
      case LimitStatus.exceeded:
        return Colors.red;
      case LimitStatus.unlimited:
        return Colors.amber;
    }
  }

  /// 저장 상태에 따른 아이콘
  IconData _getStorageStatusIcon() {
    switch (_storageStatus) {
      case LimitStatus.available:
        return Icons.storage;
      case LimitStatus.warning:
        return Icons.storage;
      case LimitStatus.exceeded:
        return Icons.storage;
      case LimitStatus.unlimited:
        return Icons.cloud_done;
    }
  }

  /// 프리미엄 업그레이드 다이얼로그
  void _showPremiumUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Text('프리미엄 구독'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('프리미엄 구독의 혜택:'),
            SizedBox(height: 12),
            Text('✅ 무제한 AI 루틴 생성'),
            Text('✅ 무제한 루틴 저장'),
            Text('✅ 고급 통계 및 분석'),
            Text('✅ 클라우드 백업'),
            Text('✅ 광고 없는 경험'),
            Text('✅ 우선 고객 지원'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('나중에'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 프리미엄 구독 페이지로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프리미엄 구독 기능 준비 중입니다')),
              );
            },
            child: const Text('구독하기'),
          ),
        ],
      ),
    );
  }

  /// 검색 바 위젯
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: '루틴 제목이나 설명으로 검색...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingM,
          ),
        ),
      ),
    );
  }

  /// 필터 칩들 위젯
  Widget _buildFilterChips() {
    if (!_isSearching && _selectedConcepts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSearching || _selectedConcepts.isNotEmpty)
            Row(
              children: [
                Text(
                  '필터',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_selectedConcepts.isNotEmpty)
                  TextButton(
                    onPressed: _clearConceptFilters,
                    child: const Text('모두 해제'),
                  ),
              ],
            ),
          const SizedBox(height: AppTheme.spacingS),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
            child: Row(
              children: RoutineConcept.values.map((concept) {
                final isSelected = _selectedConcepts.contains(concept);
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: FilterChip(
                    label: Text(concept.displayName),
                    selected: isSelected,
                    onSelected: (selected) => _toggleConceptFilter(concept),
                    selectedColor: concept.color.withValues(alpha: 0.2),
                    checkmarkColor: concept.color,
                    side: BorderSide(
                      color: isSelected ? concept.color : AppTheme.dividerColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 검색 결과 위젯
  Widget _buildSearchResults() {
    final allFilteredRoutines = [..._filteredAllRoutines, ..._filteredFavoriteRoutines]
        .toSet() // 중복 제거
        .toList();

    if (allFilteredRoutines.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: '검색 결과가 없어요',
        subtitle: '다른 검색어나 필터를 시도해보세요',
        buttonText: '필터 초기화',
        onButtonPressed: _clearFilters,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRoutines,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        itemCount: allFilteredRoutines.length,
        itemBuilder: (context, index) {
          final routine = allFilteredRoutines[index];
          return RoutineSummaryCard(
            routine: routine,
            onTap: () => _openRoutineDetail(routine),
            onFavoriteToggle: () => _toggleFavorite(routine.id),
            onDelete: () => _deleteRoutine(routine.id),
            onCopy: () => _loadRoutines(),
            onActiveToggle: () => _loadRoutines(),
          );
        },
      ),
    );
  }

  /// 검색 토글
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _applyFilters();
      }
    });
  }

  /// 검색어 변경 처리
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  /// 검색어 초기화
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _applyFilters();
  }

  /// 컨셉 필터 토글
  void _toggleConceptFilter(RoutineConcept concept) {
    setState(() {
      if (_selectedConcepts.contains(concept)) {
        _selectedConcepts.remove(concept);
      } else {
        _selectedConcepts.add(concept);
      }
    });
    _applyFilters();
  }

  /// 컨셉 필터 모두 해제
  void _clearConceptFilters() {
    setState(() {
      _selectedConcepts.clear();
    });
    _applyFilters();
  }

  /// 모든 필터 초기화
  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedConcepts.clear();
    });
    _applyFilters();
  }

  /// 필터 적용
  void _applyFilters() {
    setState(() {
      _filteredAllRoutines = _filterRoutines(_allRoutines);
      _filteredFavoriteRoutines = _filterRoutines(_favoriteRoutines);
    });
  }

  /// 루틴 필터링 로직
  List<DailyRoutine> _filterRoutines(List<DailyRoutine> routines) {
    var filtered = routines;

    // 검색어 필터링
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((routine) {
        return routine.title.toLowerCase().contains(query) ||
               routine.description.toLowerCase().contains(query) ||
               routine.concept.displayName.toLowerCase().contains(query);
      }).toList();
    }

    // 컨셉 필터링
    if (_selectedConcepts.isNotEmpty) {
      filtered = filtered.where((routine) {
        return _selectedConcepts.contains(routine.concept);
      }).toList();
    }

    return filtered;
  }
}