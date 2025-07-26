import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bot_toast/bot_toast.dart';

import 'presentation/theme/app_theme.dart';
import 'core/config/app_router.dart';

/// Main application widget
class RoutineCraftApp extends ConsumerWidget {
  const RoutineCraftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'RoutineCraft',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // 라이트 테마만 사용
      routerConfig: appRouter.config(),
      // BotToast 설정
      builder: BotToastInit(),
    );
  }
}
