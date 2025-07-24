import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../../core/config/app_router.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../providers/routine_list_provider.dart';
import '../../providers/routine_search_provider.dart';
import '../../widgets/routine/tabs/all_routines_tab.dart';
import '../../widgets/routine/tabs/favorite_routines_tab.dart';
import '../../widgets/routine/search/routine_search_bar.dart';
import '../../widgets/routine/search/routine_filter_chips.dart';
import '../../widgets/routine/storage/routine_storage_indicator.dart';
import '../../widgets/common/common_app_bar.dart';
import 'routine_detail_screen_new.dart';

/// 리팩토링된 내 루틴 목록 화면
@RoutePage()
class MyRoutinesScreenNew extends StatefulWidget {
  const MyRoutinesScreenNew({super.key});

  @override
  State<MyRoutinesScreenNew> createState() => _MyRoutinesScreenNewState();
}

class _MyRoutinesScreenNewState extends State<MyRoutinesScreenNew>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoutineListProvider>().loadRoutines();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoutineListProvider()),
        ChangeNotifierProvider(create: (_) => RoutineSearchProvider()),
      ],
      child: Consumer2<RoutineListProvider, RoutineSearchProvider>(
        builder: (context, routineProvider, searchProvider, child) {
          // 필터 적용
          WidgetsBinding.instance.addPostFrameCallback((_) {
            routineProvider.applyFilters(
              searchProvider.searchQuery,
              searchProvider.selectedConcepts,
            );
          });

          return Scaffold(
            appBar: _buildAppBar(context, searchProvider),
            body: routineProvider.isLoading
                ? _buildLoadingWidget()
                : Column(
                    children: [
                      // 저장 공간 표시기
                      RoutineStorageIndicator(
                        onUpgradePressed: _showPremiumUpgradeDialog,
                      ),
                      
                      // 검색바 (검색 모드일 때만 표시)
                      if (searchProvider.isSearching) const RoutineSearchBar(),
                      
                      // 필터 칩 (검색 모드일 때만 표시)
                      if (searchProvider.isSearching) const RoutineFilterChips(),
                      
                      // 탭 바
                      _buildTabBar(),
                      
                      // 탭 뷰
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            AllRoutinesTab(
                              onCreateRoutine: _createNewRoutine,
                              onRoutineDetail: _openRoutineDetail,
                            ),
                            FavoriteRoutinesTab(
                              onSwitchToAllTab: () => _tabController.animateTo(0),
                              onRoutineDetail: _openRoutineDetail,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: _buildFloatingActionButton(),
          );
        },
      ),
    );
  }

  /// 앱바 구성
  PreferredSizeWidget _buildAppBar(BuildContext context, RoutineSearchProvider searchProvider) {
    return CommonAppBar(
      title: '내 루틴',
      actions: [
        IconButton(
          icon: Icon(searchProvider.isSearching ? Icons.search_off : Icons.search),
          onPressed: searchProvider.toggleSearch,
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'sort',
              child: Row(
                children: [
                  Icon(Icons.sort),
                  SizedBox(width: 8),
                  Text('정렬'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.clear_all, color: Colors.red),
                  SizedBox(width: 8),
                  Text('전체 삭제', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 탭바 구성
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Theme.of(context).primaryColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: '전체'),
          Tab(text: '즐겨찾기'),
        ],
      ),
    );
  }

  /// 로딩 위젯
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            '루틴을 불러오는 중...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 플로팅 액션 버튼
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _createNewRoutine,
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  /// 메뉴 선택 처리
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'sort':
        _showSortOptions();
        break;
      case 'clear_all':
        _showClearAllDialog();
        break;
    }
  }

  /// 정렬 옵션 다이얼로그
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('최근 생성순'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('이름순'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('즐겨찾기순'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 전체 삭제 확인 다이얼로그
  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 루틴 삭제'),
        content: const Text('모든 루틴을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<RoutineListProvider>().clearAllRoutines();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  /// 프리미엄 업그레이드 다이얼로그
  void _showPremiumUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프리미엄으로 업그레이드'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('프리미엄 기능:'),
            SizedBox(height: 8),
            Text('• 무제한 루틴 저장'),
            Text('• 무제한 AI 생성'),
            Text('• 고급 통계 기능'),
            Text('• 우선 고객 지원'),
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
              // TODO: 프리미엄 구매 페이지로 이동
            },
            child: const Text('업그레이드'),
          ),
        ],
      ),
    );
  }

  /// 새 루틴 생성
  void _createNewRoutine() {
    context.router.push(const UserInputRoute());
  }

  /// 루틴 상세 화면 열기
  void _openRoutineDetail(DailyRoutine routine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineDetailScreenNew(routine: routine),
      ),
    );
  }
}