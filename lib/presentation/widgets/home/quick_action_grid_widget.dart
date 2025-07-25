import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../domain/repositories/usage_repository.dart';
import '../../../di/service_locator.dart';
import '../../screens/routine/user_input_screen.dart';
import '../../screens/routine/my_routines_screen.dart';
import '../../screens/routine/today_routines_screen.dart';
import '../../screens/stats/stats_screen.dart';
import '../../screens/settings/settings_screen.dart';

class QuickActionGridWidget extends ConsumerStatefulWidget {
  final int totalRoutines;

  const QuickActionGridWidget({super.key, required this.totalRoutines});

  @override
  ConsumerState<QuickActionGridWidget> createState() => _QuickActionGridWidgetState();
}

class _QuickActionGridWidgetState extends ConsumerState<QuickActionGridWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        _buildActionGrid(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '빠른 실행',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("전체 메뉴는 준비 중입니다.")),
              );
            },
            child: const Text(
              '더보기',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid() {
    final quickActions = [
      QuickActionIcon(
        icon: Icons.add_circle_outline,
        label: '새 루틴',
        color: const Color(0xFF6366F1),
        onTap: _handleNewRoutine,
      ),
      QuickActionIcon(
        icon: Icons.folder_open_outlined,
        label: '내 루틴',
        color: const Color(0xFF059669),
        badge: '${widget.totalRoutines}',
        onTap: _navigateToMyRoutines,
      ),
      QuickActionIcon(
        icon: Icons.trending_up_outlined,
        label: '통계',
        color: const Color(0xFFDC2626),
        onTap: _navigateToStats,
      ),
      QuickActionIcon(
        icon: Icons.schedule,
        label: '오늘루틴',
        color: const Color(0xFF7C3AED),
        onTap: _navigateToTodayRoutine,
      ),
      QuickActionIcon(
        icon: Icons.settings_outlined,
        label: '설정',
        color: const Color(0xFF64748B),
        onTap: _navigateToSettings,
      ),
    ];

    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              for (var action in quickActions) ...[
                action,
                const SizedBox(width: 24),
              ],
              const SizedBox(width: 8),
            ],
          ),
        ),
        if (quickActions.length > 4) const AnimatedMoreHint()
      ],
    );
  }

  void _pushScreen(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _handleNewRoutine() async {
    final usageRepository = getIt<UsageRepository>();
    final canGenerate = await usageRepository.canGenerate();

    if (!canGenerate && mounted) {
      _showUsageLimitDialog();
      return;
    }

    _pushScreen(const UserInputScreen());
  }

  void _navigateToMyRoutines() => _pushScreen(const MyRoutinesScreen());
  void _navigateToTodayRoutine() => _pushScreen(const TodayRoutinesScreen());
  void _navigateToStats() => _pushScreen(const StatsScreen());
  void _navigateToSettings() => _pushScreen(const SettingsScreen());

  void _showUsageLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일일 생성 횟수 초과'),
        content: const Text('오늘 AI 루틴 생성 횟수를 모두 사용했습니다.\n내일 다시 시도해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

class QuickActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const QuickActionIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: 0,
                    right: 3,
                    child: Transform.translate(
                      offset: const Offset(2, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedMoreHint extends StatelessWidget {
  const AnimatedMoreHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4,
      top: 0,
      child: Container(
        height: 56,
        width: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFFF8FAFC).withValues(alpha: 0.0),
              const Color(0xFFF8FAFC).withValues(alpha: 0.8),
              const Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: Lottie.asset(
          'assets/lottie/more_hint.json',
          width: 20,
          height: 20,
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}