import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/theme/app_theme.dart';
import 'core/config/app_router.dart';

/// Main application widget
class BaseApp extends ConsumerWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'BaseApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter.config(),
    );
  }
}
