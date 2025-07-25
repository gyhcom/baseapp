import 'package:flutter/material.dart';
import '../../screens/routine/today_routines_screen.dart';
import '../../../domain/entities/daily_routine.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../di/service_locator.dart';

/// 오늘의 루틴 대시보드 위젯
class TodayDashboardWidget extends StatefulWidget {
  const TodayDashboardWidget({super.key});

  @override
  State<TodayDashboardWidget> createState() => _TodayDashboardWidgetState();
}

class _TodayDashboardWidgetState extends State<TodayDashboardWidget> {
  final RoutineRepository _routineRepository = getIt<RoutineRepository>();
  List<DailyRoutine> _activeRoutines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveRoutines();
  }

  Future<void> _loadActiveRoutines() async {
    try {
      final activeRoutines = await _routineRepository.getActiveRoutines();
      setState(() {
        _activeRoutines = activeRoutines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('활성화된 루틴 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          
          const SizedBox(height: 24),
          
          // 메트릭스 카드들
          _buildMetricsRow(),
          
          const SizedBox(height: 20),
          
          // 진행률 바
          _buildProgressBar(),
        ],
      ),
    );
  }

  /// 헤더 섹션
  Widget _buildHeader() {
    return Row(
      children: [
        Stack(
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
            
            // LIVE 텍스트를 통계 아이콘 상단 중앙에 배치
            Positioned(
              top: 1,
              left: 2,
              right: 0,
              child: Center(
                child: Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _activeRoutines.isEmpty ? '루틴 현황' : '오늘의 진행상황',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _activeRoutines.isEmpty 
                    ? '활성화된 루틴을 설정하여 하루를 계획해보세요'
                    : '실시간으로 업데이트되는 루틴 성과를 확인하세요',
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
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TodayRoutinesScreen(),
                  ),
                );
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
        ),
      ],
    );
  }

  /// 메트릭스 카드들
  Widget _buildMetricsRow() {
    if (_isLoading) {
      return Row(
        children: [
          Expanded(child: _buildLoadingCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildLoadingCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildLoadingCard()),
        ],
      );
    }

    if (_activeRoutines.isEmpty) {
      return _buildEmptyState();
    }

    final totalItems = _activeRoutines.fold<int>(
      0, (sum, routine) => sum + routine.items.length,
    );
    final completedItems = _activeRoutines.fold<int>(
      0, (sum, routine) => sum + routine.items.where((item) => item.isCompleted).length,
    );
    final totalMinutes = _activeRoutines.fold<int>(
      0, (sum, routine) => sum + routine.items.fold<int>(
        0, (sum2, item) => sum2 + item.duration.inMinutes,
      ),
    );
    final completedMinutes = _activeRoutines.fold<int>(
      0, (sum, routine) => sum + routine.items
          .where((item) => item.isCompleted)
          .fold<int>(0, (sum2, item) => sum2 + item.duration.inMinutes),
    );
    
    final progress = totalItems > 0 ? (completedItems / totalItems * 100).round() : 0;
    final remainingMinutes = totalMinutes - completedMinutes;

    return Row(
      children: [
        Expanded(
          child: MetricCard(
            value: '$progress%',
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
          child: MetricCard(
            value: '$completedItems/$totalItems',
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
          child: MetricCard(
            value: '${remainingMinutes}분',
            label: '남은 시간',
            icon: Icons.schedule,
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            bgColor: const Color(0xFFEF4444).withOpacity(0.08),
          ),
        ),
      ],
    );
  }

  /// 진행률 바
  Widget _buildProgressBar() {
    if (_isLoading || _activeRoutines.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalItems = _activeRoutines.fold<int>(
      0, (sum, routine) => sum + routine.items.length,
    );
    final completedItems = _activeRoutines.fold<int>(
      0, (sum, routine) => sum + routine.items.where((item) => item.isCompleted).length,
    );
    
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;
    final progressPercent = (progress * 100).round();

    return Container(
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
                '$progressPercent% 완료',
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
              widthFactor: progress,
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
    );
  }

  /// 로딩 카드
  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 30,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 50,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// 빈 상태
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 48,
            color: const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 12),
          Text(
            '활성화된 루틴이 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '루틴을 활성화하여 오늘의 일정을 시작하세요',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 메트릭 카드 위젯
class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Gradient gradient;
  final Color bgColor;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
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
}