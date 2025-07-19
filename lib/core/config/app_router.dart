import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/todos/todo_list_screen.dart';
import '../../presentation/screens/todos/todo_detail_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/routine/user_input_screen.dart';
import '../../presentation/screens/routine/concept_selection_screen.dart';
import '../../presentation/screens/routine/routine_generation_screen.dart';
import '../../domain/entities/routine_concept.dart';

part 'app_router.gr.dart';

/// App router configuration using AutoRoute
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    // ========== SPLASH ==========
    AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),

    // ========== AUTH ROUTES ==========
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegisterRoute.page, path: '/register'),

    // ========== MAIN APP ROUTES ==========
    AutoRoute(
      page: HomeWrapperRoute.page,
      path: '/home',
      children: [
        AutoRoute(page: HomeRoute.page, path: '', initial: true),
        AutoRoute(page: TodoListRoute.page, path: 'todos'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),

    // ========== DETAIL ROUTES ==========
    AutoRoute(page: TodoDetailRoute.page, path: '/todo/:todoId'),
    
    // ========== ROUTINE ROUTES ==========
    AutoRoute(page: UserInputRoute.page, path: '/routine/input'),
    AutoRoute(page: ConceptSelectionRoute.page, path: '/routine/concept'),
    AutoRoute(page: RoutineGenerationRoute.page, path: '/routine/generation'),

    // ========== FALLBACK ==========
    /// Redirect to splash if route is not found
    RedirectRoute(path: '*', redirectTo: '/splash'),
  ];
}

/// Route pages definition
@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const SplashScreen();
}

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => const LoginScreen();
}

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => const RegisterScreen();
}

@RoutePage()
class HomeWrapperPage extends StatelessWidget {
  const HomeWrapperPage({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const HomeScreen();
}

@RoutePage()
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) => const TodoListScreen();
}

@RoutePage()
class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({super.key, @PathParam('todoId') required this.todoId});

  final String todoId;

  @override
  Widget build(BuildContext context) => TodoDetailScreen(todoId: todoId);
}

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const ProfileScreen();
}

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => const SettingsScreen();
}

@RoutePage()
class UserInputPage extends StatelessWidget {
  const UserInputPage({super.key});

  @override
  Widget build(BuildContext context) => const UserInputScreen();
}

@RoutePage()
class ConceptSelectionPage extends StatelessWidget {
  final String name;
  final int age;
  final String job;
  final List<String> hobbies;
  final String additionalInfo;
  
  const ConceptSelectionPage({
    super.key,
    required this.name,
    required this.age,
    required this.job,
    required this.hobbies,
    required this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) => ConceptSelectionScreen(
    name: name,
    age: age,
    job: job,
    hobbies: hobbies,
    additionalInfo: additionalInfo,
  );
}

@RoutePage()
class RoutineGenerationPage extends StatelessWidget {
  final String name;
  final int age;
  final String job;
  final List<String> hobbies;
  final String additionalInfo;
  final String conceptName;
  
  const RoutineGenerationPage({
    super.key,
    required this.name,
    required this.age,
    required this.job,
    required this.hobbies,
    required this.additionalInfo,
    required this.conceptName,
  });

  @override
  Widget build(BuildContext context) {
    // conceptName을 RoutineConcept enum으로 변환
    final concept = RoutineConcept.values.firstWhere(
      (c) => c.name == conceptName,
      orElse: () => RoutineConcept.workLifeBalance,
    );
    
    return RoutineGenerationScreen(
      name: name,
      age: age,
      job: job,
      hobbies: hobbies,
      additionalInfo: additionalInfo,
      concept: concept,
    );
  }
}

/// Navigation helper methods for AppRouter
extension AppRouterExtension on StackRouter {
  /// Navigate to login screen
  Future<void> pushLogin() => push(const LoginRoute());

  /// Navigate to register screen
  Future<void> pushRegister() => push(const RegisterRoute());

  /// Navigate to home and clear stack
  Future<void> pushAndClearToHome() => navigate(const HomeWrapperRoute());

  /// Navigate to todo detail
  Future<void> pushTodoDetail(String todoId) =>
      push(TodoDetailRoute(todoId: todoId));
  
  /// Navigate to user input screen
  Future<void> pushUserInput() => push(const UserInputRoute());

  /// Pop to root
  void popToRoot() => popUntilRoot();

  /// Can pop check
  bool get canPopCheck => canPop();
}

/// Route information for type-safe navigation
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String todos = '/home/todos';
  static const String profile = '/home/profile';
  static const String settings = '/home/settings';
  static const String userInput = '/routine/input';

  /// Generate todo detail route
  static String todoDetail(String todoId) => '/todo/$todoId';
}
