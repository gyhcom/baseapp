import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependencies
  await setupDependencies();

  runApp(const ProviderScope(child: BaseApp()));
}
