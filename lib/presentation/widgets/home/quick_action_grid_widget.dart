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

  /// 섹션 헤더 - 심플한 디자인
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '빠른 실행',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          
          GestureDetector(
            onTap: () {
              // TODO: 모든 기능 화면으로 이동
            },
            child: Text(
              '더보기',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 액션 그리드 - 1줄 가로 스크롤 방식
  Widget _buildActionGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          QuickActionIcon(
            icon: Icons.add_circle_outline,
            label: '새 루틴',
            color: const Color(0xFF6366F1),
            onTap: () => _handleNewRoutine(),
          ),
          
          const SizedBox(width: 24),
          
          QuickActionIcon(
            icon: Icons.folder_open_outlined,
            label: '내 루틴',
            color: const Color(0xFF059669),
            badge: '${widget.totalRoutines}',
            onTap: () => _navigateToMyRoutines(),
          ),
          
          const SizedBox(width: 24),
          
          QuickActionIcon(
            icon: Icons.trending_up_outlined,
            label: '통계',
            color: const Color(0xFFDC2626),
            onTap: () {
              // TODO: 통계 화면
            },
          ),
          
          const SizedBox(width: 24),
          
          QuickActionIcon(
            icon: Icons.schedule,
            label: '오늘루틴',
            color: const Color(0xFF7C3AED),
            onTap: () {
              // TODO: 오늘의 루틴 화면
            },
          ),
          
          const SizedBox(width: 24),
          
          QuickActionIcon(
            icon: Icons.settings_outlined,
            label: '설정',
            color: const Color(0xFF64748B),
            onTap: () {
              // TODO: 설정 화면
            },
          ),
        ],
      ),
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

/// 퀵 액션 아이콘 위젯 (참고 이미지 스타일)
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘 컨테이너
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                
                // 뱃지 (숫자)
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -4,
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
              ],
            ),
            
            const SizedBox(height: 8),
            
            // 라벨
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
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