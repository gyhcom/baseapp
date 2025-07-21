import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/usage_repository.dart';
import '../../../di/service_locator.dart';
import '../../screens/routine/user_input_screen.dart';
import '../../screens/routine/my_routines_screen.dart';

/// 빠른 실행 그리드 위젯
class QuickActionGridWidget extends ConsumerStatefulWidget {
  final int totalRoutines;

  const QuickActionGridWidget({
    super.key,
    required this.totalRoutines,
  });

  @override
  ConsumerState<QuickActionGridWidget> createState() => _QuickActionGridWidgetState();
}

class _QuickActionGridWidgetState extends ConsumerState<QuickActionGridWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        _buildSectionHeader(),
        
        const SizedBox(height: 16),
        
        // 액션 그리드
        _buildActionGrid(),
      ],
    );
  }

  /// 섹션 헤더
  Widget _buildSectionHeader() {
    return Row(
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
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '자주 사용하는 기능을 빠르게 이용하세요',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
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
    );
  }

  /// 액션 그리드
  Widget _buildActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        ActionCard(
          icon: Icons.add_circle_outline,
          title: '새 루틴 생성',
          subtitle: 'AI 맞춤 루틴',
          gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          onTap: () => _handleNewRoutine(),
        ),
        
        ActionCard(
          icon: Icons.folder_open_outlined,
          title: '내 루틴',
          subtitle: '${widget.totalRoutines}개 저장됨',
          gradient: const [Color(0xFF059669), Color(0xFF10B981)],
          onTap: () => _navigateToMyRoutines(),
        ),
        
        ActionCard(
          icon: Icons.trending_up_outlined,
          title: '통계 분석',
          subtitle: '루틴 성과 확인',
          gradient: const [Color(0xFFDC2626), Color(0xFFEF4444)],
          onTap: () {
            // TODO: 통계 화면
          },
        ),
        
        ActionCard(
          icon: Icons.settings_outlined,
          title: '설정',
          subtitle: '앱 설정 관리',
          gradient: const [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
          onTap: () {
            // TODO: 설정 화면
          },
        ),
      ],
    );
  }

  /// 새 루틴 생성 처리
  Future<void> _handleNewRoutine() async {
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
  }

  /// 내 루틴으로 이동
  void _navigateToMyRoutines() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MyRoutinesScreen(),
      ),
    );
  }

  /// 사용량 제한 다이얼로그
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

/// 액션 카드 위젯
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: gradient.first.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 상단: 아이콘
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            
            // 하단: 텍스트
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}