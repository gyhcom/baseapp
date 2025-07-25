import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app.dart';
import 'di/service_locator.dart';
import 'presentation/screens/routine/routine_notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  try {
    // Initialize Firebase with options for iOS
    if (Platform.isIOS) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
          appId: '1:743929366941:ios:15884a7d38c846a6716eae',
          messagingSenderId: '743929366941',
          projectId: 'routinecraft-ios',
          storageBucket: 'routinecraft-ios.appspot.com',
          iosBundleId: 'com.routinecraft.app',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    print('✅ Firebase 초기화 성공');
  } catch (e) {
    print('❌ Firebase 초기화 실패: $e');
    print('📋 Firebase 설정 파일을 확인해주세요:');
    print('   - android/app/google-services.json');
    print('   - ios/Runner/GoogleService-Info.plist');
  }

  // Initialize timezone database
  tz.initializeTimeZones();

  // Setup dependencies
  await setupDependencies();

  // Initialize notifications
  await RoutineNotificationHelper.initializeNotifications();

  runApp(const ProviderScope(child: RoutineCraftApp()));
}
