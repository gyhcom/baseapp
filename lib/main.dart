import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app.dart';
import 'di/service_locator.dart';
import 'presentation/screens/routine/routine_notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database
  tz.initializeTimeZones();

  // Setup dependencies
  await setupDependencies();

  // Initialize notifications
  await RoutineNotificationHelper.initializeNotifications();

  runApp(const ProviderScope(child: RoutineCraftApp()));
}
