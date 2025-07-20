import 'package:flutter/material.dart';
import '../routine/my_routines_screen.dart';
import '../routine/user_input_screen.dart';
import '../routine/today_routine_screen.dart';
import '../../theme/app_theme.dart';
import '../../widgets/usage/usage_indicator.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/entities/user_usage.dart';
import '../../../di/service_locator.dart';

/// Home screen - main dashboard
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RoutineRepository _routineRepository = getIt<RoutineRepository>();
  int _totalRoutines = 0;
  int _favoriteRoutines = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final allRoutines = await _routineRepository.getSavedRoutines();
      final favoriteRoutines = await _routineRepository.getFavoriteRoutines();
      
      setState(() {
        _totalRoutines = allRoutines.length;
        _favoriteRoutines = favoriteRoutines.length;
      });
    } catch (e) {
      print('홈 화면 통계 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // 다이나믹 헤더
          _buildDynamicHeader(),
          
          // 메인 콘텐츠
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // 오늘의 루틴 대시보드
                  _buildTodayDashboard(),
                  
                  const SizedBox(height: 30),
                  
                  // 퀵 액션 그리드
                  _buildQuickActionGrid(),
                  
                  const SizedBox(height: 30),
                  
                  // 인사이트 섹션
                  _buildInsightsSection(),
                  
                  const SizedBox(height: 30),
                  
                  // 최근 활동
                  _buildEnhancedRecentActivity(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 다이나믹 헤더 (SliverAppBar)
  Widget _buildDynamicHeader() {
    final currentHour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;
    
    if (currentHour < 12) {
      greeting = '좋은 아침이에요!';
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (currentHour < 18) {
      greeting = '좋은 오후에요!';
      greetingIcon = Icons.wb_sunny;
    } else {
      greeting = '좋은 저녁이에요!';
      greetingIcon = Icons.nightlight_round;
    }

    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              'RoutineCraft',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
                Color(0xFFf093fb),
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                              const SizedBox(height: 60),
                              
                              // 인사말과 시간
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                                    ),
                                    child: Icon(
                                      greetingIcon,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          greeting,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '새로운 하루, 새로운 루틴을 시작해보세요',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
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
      // 검색/프로필 아이콘
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // TODO: 검색 기능
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () {
            // TODO: 프로필 화면으로 이동
          },
        ),
      ],
    );
  }

  /// 오늘의 루틴 대시보드
  /// 오늘의 루틴 대시보드 (고급 디자인)
  Widget _buildTodayDashboard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 섹션
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    stops: [0.0, 0.6, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.insights,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '오늘의 진행상황',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '실시간으로 업데이트되는 루틴 성과를 확인하세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    // TODO: 오늘의 루틴으로 이동
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '전체보기',
                        style: TextStyle(
                          color: const Color(0xFF6366F1),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: const Color(0xFF6366F1),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 메트릭스 카드들
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  value: '73%',
                  label: '완료율',
                  icon: Icons.trending_up,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  bgColor: const Color(0xFF10B981).withOpacity(0.08),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  value: '8/11',
                  label: '완료 항목',
                  icon: Icons.check_circle_outline,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  bgColor: const Color(0xFF8B5CF6).withOpacity(0.08),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  value: '45분',
                  label: '남은 시간',
                  icon: Icons.schedule,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  bgColor: const Color(0xFFEF4444).withOpacity(0.08),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 진행률 바
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF8FAFC),
                  const Color(0xFFF1F5F9).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '전체 진행률',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    Text(
                      '73% 완료',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.73,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 메트릭 카드 위젯
  Widget _buildMetricCard({
    required String value,
    required String label,
    required IconData icon,
    required Gradient gradient,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 퀵 액션 그리드 (고급 디자인)
  Widget _buildQuickActionGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.dashboard_customize,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '빠른 실행',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    '자주 사용하는 기능들을 빠르게 이용하세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '모든 기능',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF6366F1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.apps,
                    color: const Color(0xFF6366F1),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildModernActionCard(
              icon: Icons.add_circle_outline,
              title: '새 루틴 생성',
              subtitle: 'AI 맞춤 루틴',
              gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              onTap: () async {
                final usageRepository = getIt<UsageRepository>();
                final canGenerate = await usageRepository.canGenerate();
                
                if (!canGenerate && mounted) {
                  _showUsageLimitDialog();
                  return;
                }
                
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UserInputScreen(),
                  ),
                );
              },
            ),
            
            _buildModernActionCard(
              icon: Icons.folder_open_outlined,
              title: '내 루틴',
              subtitle: '$_totalRoutines개 저장됨',
              gradient: const [Color(0xFF059669), Color(0xFF10B981)],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyRoutinesScreen(),
                  ),
                ).then((_) => _loadStats());
              },
            ),
            
            _buildModernActionCard(
              icon: Icons.trending_up_outlined,
              title: '통계 분석',
              subtitle: '루틴 성과 확인',
              gradient: const [Color(0xFFDC2626), Color(0xFFEF4444)],
              onTap: () {
                // TODO: 통계 화면
              },
            ),
            
            _buildModernActionCard(
              icon: Icons.settings_outlined,
              title: '설정',
              subtitle: '앱 환경설정',
              gradient: const [Color(0xFF7C3AED), Color(0xFF9333EA)],
              onTap: () {
                // TODO: 설정 화면
              },
            ),
          ],
        ),
      ],
    );
  }

  /// 모던 액션 카드
  Widget _buildModernActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.95),
              gradient.first.withOpacity(0.02),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: gradient.first.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘과 장식 요소
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                // 장식용 도트
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: gradient.first.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 텍스트 섹션
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: gradient.first.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: gradient.first,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // 액션 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: gradient.first.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: gradient.first,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 인사이트 섹션
  Widget _buildInsightsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 인사이트',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      '개인화된 루틴 분석과 추천',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  color: Color(0xFFDC2626),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이번 주 가장 성공적인 루틴',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '아침 운동 루틴 - 90% 완료율',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
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
    );
  }

  /// 향상된 최근 활동
  Widget _buildEnhancedRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              '최근 활동',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Spacer(),
            Text(
              '더보기',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                icon: Icons.check_circle_outline,
                title: '아침 운동 루틴 완료',
                time: '2시간 전',
                color: const Color(0xFF059669),
              ),
              const Divider(height: 24),
              _buildActivityItem(
                icon: Icons.add_circle_outline,
                title: '새로운 독서 루틴 생성',
                time: '1일 전',
                color: const Color(0xFF6366F1),
              ),
              const Divider(height: 24),
              _buildActivityItem(
                icon: Icons.star_outline,
                title: '명상 루틴을 즐겨찾기에 추가',
                time: '2일 전',
                color: const Color(0xFFDC2626),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빠른 실행',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // 오늘의 루틴 시작하기 (대형 카드)
        _buildTodayRoutineCard(),
        
        const SizedBox(height: AppTheme.spacingM),
        
        Row(
          children: [
            // 새 루틴 생성
            Expanded(
              child: _buildActionCardWithUsage(
                icon: Icons.add_circle_outline,
                title: '새 루틴 생성',
                subtitle: 'AI로 맞춤 루틴 만들기',
                color: AppTheme.primaryColor,
                onTap: () async {
                  // 사용량 체크
                  final usageRepository = getIt<UsageRepository>();
                  final canGenerate = await usageRepository.canGenerate();
                  
                  if (!canGenerate && mounted) {
                    _showUsageLimitDialog();
                    return;
                  }
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserInputScreen(),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingM),
            
            // 내 루틴 보기
            Expanded(
              child: _buildActionCard(
                icon: Icons.folder_open,
                title: '내 루틴 ($_totalRoutines)',
                subtitle: '저장된 루틴 관리',
                color: AppTheme.accentColor,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyRoutinesScreen(),
                    ),
                  ).then((_) => _loadStats()); // 돌아올 때 통계 새로고침
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        // 사용량 표시
        const UsageIndicator(),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.mediumRadius,
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: AppTheme.mediumRadius,
            boxShadow: [AppTheme.cardShadow],
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 4),
              
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCardWithUsage({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FutureBuilder<UserUsage>(
      future: getIt<UsageRepository>().getCurrentUsage(),
      builder: (context, snapshot) {
        final isEnabled = snapshot.hasData && snapshot.data!.canGenerateToday;
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: AppTheme.mediumRadius,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: isEnabled ? AppTheme.surfaceColor : AppTheme.surfaceColor.withOpacity(0.5),
                borderRadius: AppTheme.mediumRadius,
                boxShadow: [AppTheme.cardShadow],
                border: Border.all(
                  color: isEnabled ? color.withOpacity(0.3) : AppTheme.textSecondaryColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: (isEnabled ? color : AppTheme.textSecondaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: isEnabled ? color : AppTheme.textSecondaryColor,
                          size: 28,
                        ),
                      ),
                      
                      // 사용량 뱃지
                      if (snapshot.hasData)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: snapshot.data!.availableGenerationsToday > 0 
                                  ? Colors.green 
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${snapshot.data!.availableGenerationsToday}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? null : AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    isEnabled ? subtitle : '사용량 초과',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUsageLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 8),
            Text('사용량 한도 초과'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('오늘 AI 루틴 생성 횟수를 모두 사용하셨습니다.'),
            const SizedBox(height: 16),
            const Text('더 많은 루틴을 생성하려면:'),
            const SizedBox(height: 8),
            const Text('• 프리미엄 구독 (무제한 생성)'),
            const Text('• 친구 초대하여 보너스 받기'),
            const Text('• 소셜 공유하여 보너스 받기'),
            const Text('• 내일 다시 시도하기'),
            const SizedBox(height: 16),
            FutureBuilder<UserUsage>(
              future: getIt<UsageRepository>().getCurrentUsage(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                
                final usage = snapshot.data!;
                return Text(
                  '다음 리셋: ${usage.hoursUntilReset}시간 후',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 프리미엄 구독 화면으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프리미엄 기능 준비 중입니다')),
              );
            },
            child: const Text('프리미엄 가입'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '나의 루틴 통계',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        Row(
          children: [
            // 전체 루틴 수
            Expanded(
              child: _buildStatCard(
                icon: Icons.event_note,
                label: '전체 루틴',
                value: '$_totalRoutines',
                color: AppTheme.primaryColor,
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingM),
            
            // 즐겨찾기 루틴 수
            Expanded(
              child: _buildStatCard(
                icon: Icons.favorite,
                label: '즐겨찾기',
                value: '$_favoriteRoutines',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: AppTheme.mediumRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 활동',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: AppTheme.mediumRadius,
            boxShadow: [AppTheme.cardShadow],
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.timeline,
                  size: 40,
                  color: AppTheme.textSecondaryColor,
                ),
                
                const SizedBox(height: AppTheme.spacingS),
                
                Text(
                  '최근 활동 기능은 준비 중입니다',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayRoutineCard() {
    return FutureBuilder<List<DailyRoutine>>(
      future: _routineRepository.getSavedRoutines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildTodayRoutineLoadingCard();
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildTodayRoutineEmptyCard();
        }
        
        // 가장 최근에 사용한 루틴 또는 즐겨찾기 루틴을 선택
        final routines = snapshot.data!;
        final favoriteRoutines = routines.where((r) => r.isFavorite).toList();
        final selectedRoutine = favoriteRoutines.isNotEmpty 
            ? favoriteRoutines.first 
            : routines.first;
            
        return _buildTodayRoutineActiveCard(selectedRoutine);
      },
    );
  }

  Widget _buildTodayRoutineLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.8),
            AppTheme.accentColor.withOpacity(0.8),
          ],
        ),
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: const Row(
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(width: AppTheme.spacingM),
          Text(
            '루틴 불러오는 중...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayRoutineEmptyCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.6),
            Colors.grey.withOpacity(0.8),
          ],
        ),
        borderRadius: AppTheme.largeRadius,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: AppTheme.spacingM),
              const Expanded(
                child: Text(
                  '오늘의 루틴',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Text(
            '아직 저장된 루틴이 없습니다\n먼저 새 루틴을 생성해보세요!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayRoutineActiveCard(DailyRoutine routine) {
    final completedCount = routine.items.where((item) => item.isCompleted).length;
    final totalCount = routine.items.length;
    final progressPercent = totalCount > 0 ? completedCount / totalCount : 0.0;
    
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodayRoutineScreen(routine: routine),
          ),
        ).then((_) => _loadStats());
      },
      borderRadius: AppTheme.largeRadius,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              routine.concept.color.withOpacity(0.8),
              routine.concept.color,
            ],
          ),
          borderRadius: AppTheme.largeRadius,
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                
                const SizedBox(width: AppTheme.spacingM),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '오늘의 루틴 시작하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        routine.title,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // 진행률 표시
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(progressPercent * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // 진행률 바
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingS),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedCount / $totalCount 활동 완료',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
                
                Text(
                  progressPercent == 1.0 ? '🎉 완료!' : '진행 중',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
