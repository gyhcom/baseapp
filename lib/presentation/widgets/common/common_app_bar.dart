import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/config/app_router.dart';

/// 공통 AppBar 위젯
/// 모든 화면에서 일관된 네비게이션 경험을 제공
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showHomeButton;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showHomeButton = true,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildLeading(context),
      actions: [
        if (actions != null) ...actions!,
        if (showHomeButton) _buildHomeButton(context),
      ],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton) return null;
    
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: onBackPressed ?? () {
        if (context.router.canPop()) {
          context.router.maybePop();
        } else {
          // 뒤로 갈 수 없으면 홈으로
          context.router.navigate(const HomeWrapperRoute());
        }
      },
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    final isAtHome = context.router.current.name == 'HomeWrapperRoute' ||
                     context.router.current.name == 'HomeRoute';
    
    if (isAtHome) {
      return const SizedBox.shrink(); // 홈에서는 홈 버튼 숨김
    }
    
    return IconButton(
      icon: const Icon(Icons.home_outlined),
      tooltip: '홈으로',
      onPressed: () {
        context.router.navigate(const HomeWrapperRoute());
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}