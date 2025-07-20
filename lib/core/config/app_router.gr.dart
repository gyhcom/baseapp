// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ConceptSelectionRoute.name: (routeData) {
      final args = routeData.argsAs<ConceptSelectionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConceptSelectionPage(
          key: args.key,
          name: args.name,
          age: args.age,
          job: args.job,
          hobbies: args.hobbies,
          additionalInfo: args.additionalInfo,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    HomeWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeWrapperPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    RoutineGenerationRoute.name: (routeData) {
      final args = routeData.argsAs<RoutineGenerationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RoutineGenerationPage(
          key: args.key,
          name: args.name,
          age: args.age,
          job: args.job,
          hobbies: args.hobbies,
          additionalInfo: args.additionalInfo,
          conceptName: args.conceptName,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    TodayRoutineRoute.name: (routeData) {
      final args = routeData.argsAs<TodayRoutineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodayRoutineScreen(
          key: args.key,
          routine: args.routine,
        ),
      );
    },
    TodoDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TodoDetailRouteArgs>(
          orElse: () =>
              TodoDetailRouteArgs(todoId: pathParams.getString('todoId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoDetailPage(
          key: args.key,
          todoId: args.todoId,
        ),
      );
    },
    TodoListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodoListPage(),
      );
    },
    UserInputRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserInputPage(),
      );
    },
  };
}

/// generated route for
/// [ConceptSelectionPage]
class ConceptSelectionRoute extends PageRouteInfo<ConceptSelectionRouteArgs> {
  ConceptSelectionRoute({
    Key? key,
    required String name,
    required int age,
    required String job,
    required List<String> hobbies,
    required String additionalInfo,
    List<PageRouteInfo>? children,
  }) : super(
          ConceptSelectionRoute.name,
          args: ConceptSelectionRouteArgs(
            key: key,
            name: name,
            age: age,
            job: job,
            hobbies: hobbies,
            additionalInfo: additionalInfo,
          ),
          initialChildren: children,
        );

  static const String name = 'ConceptSelectionRoute';

  static const PageInfo<ConceptSelectionRouteArgs> page =
      PageInfo<ConceptSelectionRouteArgs>(name);
}

class ConceptSelectionRouteArgs {
  const ConceptSelectionRouteArgs({
    this.key,
    required this.name,
    required this.age,
    required this.job,
    required this.hobbies,
    required this.additionalInfo,
  });

  final Key? key;

  final String name;

  final int age;

  final String job;

  final List<String> hobbies;

  final String additionalInfo;

  @override
  String toString() {
    return 'ConceptSelectionRouteArgs{key: $key, name: $name, age: $age, job: $job, hobbies: $hobbies, additionalInfo: $additionalInfo}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeWrapperPage]
class HomeWrapperRoute extends PageRouteInfo<void> {
  const HomeWrapperRoute({List<PageRouteInfo>? children})
      : super(
          HomeWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeWrapperRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RoutineGenerationPage]
class RoutineGenerationRoute extends PageRouteInfo<RoutineGenerationRouteArgs> {
  RoutineGenerationRoute({
    Key? key,
    required String name,
    required int age,
    required String job,
    required List<String> hobbies,
    required String additionalInfo,
    required String conceptName,
    List<PageRouteInfo>? children,
  }) : super(
          RoutineGenerationRoute.name,
          args: RoutineGenerationRouteArgs(
            key: key,
            name: name,
            age: age,
            job: job,
            hobbies: hobbies,
            additionalInfo: additionalInfo,
            conceptName: conceptName,
          ),
          initialChildren: children,
        );

  static const String name = 'RoutineGenerationRoute';

  static const PageInfo<RoutineGenerationRouteArgs> page =
      PageInfo<RoutineGenerationRouteArgs>(name);
}

class RoutineGenerationRouteArgs {
  const RoutineGenerationRouteArgs({
    this.key,
    required this.name,
    required this.age,
    required this.job,
    required this.hobbies,
    required this.additionalInfo,
    required this.conceptName,
  });

  final Key? key;

  final String name;

  final int age;

  final String job;

  final List<String> hobbies;

  final String additionalInfo;

  final String conceptName;

  @override
  String toString() {
    return 'RoutineGenerationRouteArgs{key: $key, name: $name, age: $age, job: $job, hobbies: $hobbies, additionalInfo: $additionalInfo, conceptName: $conceptName}';
  }
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodayRoutineScreen]
class TodayRoutineRoute extends PageRouteInfo<TodayRoutineRouteArgs> {
  TodayRoutineRoute({
    Key? key,
    required DailyRoutine routine,
    List<PageRouteInfo>? children,
  }) : super(
          TodayRoutineRoute.name,
          args: TodayRoutineRouteArgs(
            key: key,
            routine: routine,
          ),
          initialChildren: children,
        );

  static const String name = 'TodayRoutineRoute';

  static const PageInfo<TodayRoutineRouteArgs> page =
      PageInfo<TodayRoutineRouteArgs>(name);
}

class TodayRoutineRouteArgs {
  const TodayRoutineRouteArgs({
    this.key,
    required this.routine,
  });

  final Key? key;

  final DailyRoutine routine;

  @override
  String toString() {
    return 'TodayRoutineRouteArgs{key: $key, routine: $routine}';
  }
}

/// generated route for
/// [TodoDetailPage]
class TodoDetailRoute extends PageRouteInfo<TodoDetailRouteArgs> {
  TodoDetailRoute({
    Key? key,
    required String todoId,
    List<PageRouteInfo>? children,
  }) : super(
          TodoDetailRoute.name,
          args: TodoDetailRouteArgs(
            key: key,
            todoId: todoId,
          ),
          rawPathParams: {'todoId': todoId},
          initialChildren: children,
        );

  static const String name = 'TodoDetailRoute';

  static const PageInfo<TodoDetailRouteArgs> page =
      PageInfo<TodoDetailRouteArgs>(name);
}

class TodoDetailRouteArgs {
  const TodoDetailRouteArgs({
    this.key,
    required this.todoId,
  });

  final Key? key;

  final String todoId;

  @override
  String toString() {
    return 'TodoDetailRouteArgs{key: $key, todoId: $todoId}';
  }
}

/// generated route for
/// [TodoListPage]
class TodoListRoute extends PageRouteInfo<void> {
  const TodoListRoute({List<PageRouteInfo>? children})
      : super(
          TodoListRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserInputPage]
class UserInputRoute extends PageRouteInfo<void> {
  const UserInputRoute({List<PageRouteInfo>? children})
      : super(
          UserInputRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserInputRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
