// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $welcomeRouteData,
      $futureWaitingRouteData,
      $noInternetRouteData,
      $dashboardOAuthShellRouteData,
    ];

RouteBase get $welcomeRouteData => GoRouteData.$route(
      path: '/welcome/:environment',
      name: '/welcome',
      factory: $WelcomeRouteDataExtension._fromState,
      parentNavigatorKey: WelcomeRouteData.$parentNavigatorKey,
    );

extension $WelcomeRouteDataExtension on WelcomeRouteData {
  static WelcomeRouteData _fromState(GoRouterState state) => WelcomeRouteData(
        environment: state.pathParameters['environment']!,
      );

  String get location => GoRouteData.$location(
        '/welcome/${Uri.encodeComponent(environment)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

RouteBase get $futureWaitingRouteData => GoRouteData.$route(
      path: '/future_waiting',
      name: '/future_waiting',
      factory: $FutureWaitingRouteDataExtension._fromState,
      parentNavigatorKey: FutureWaitingRouteData.$parentNavigatorKey,
    );

extension $FutureWaitingRouteDataExtension on FutureWaitingRouteData {
  static FutureWaitingRouteData _fromState(GoRouterState state) =>
      FutureWaitingRouteData(
        $extra: state.extra as dynamic,
      );

  String get location => GoRouteData.$location(
        '/future_waiting',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);
}

RouteBase get $noInternetRouteData => GoRouteData.$route(
      path: '/no_internet_screen',
      name: '/no_internet_screen',
      factory: $NoInternetRouteDataExtension._fromState,
      parentNavigatorKey: NoInternetRouteData.$parentNavigatorKey,
    );

extension $NoInternetRouteDataExtension on NoInternetRouteData {
  static NoInternetRouteData _fromState(GoRouterState state) =>
      NoInternetRouteData(
        previouspath: state.queryParameters['previouspath'],
      );

  String get location => GoRouteData.$location(
        '/no_internet_screen',
        queryParams: {
          if (previouspath != null) 'previouspath': previouspath,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

RouteBase get $dashboardOAuthShellRouteData => ShellRouteData.$route(
      factory: $DashboardOAuthShellRouteDataExtension._fromState,
      navigatorKey: DashboardOAuthShellRouteData.$navigatorKey,
      routes: [
        ShellRouteData.$route(
          factory: $DashboardShellRouteDataExtension._fromState,
          navigatorKey: DashboardShellRouteData.$navigatorKey,
          routes: [
            GoRouteData.$route(
              path: '/dashboard/home',
              name: '/dashboard/home',
              factory: $DashboardHomeRouteDataExtension._fromState,
              parentNavigatorKey: DashboardHomeRouteData.$parentNavigatorKey,
            ),
            GoRouteData.$route(
              path: '/dashboard/account',
              name: '/dashboard/account',
              factory: $DashboardAccountRouteDataExtension._fromState,
              parentNavigatorKey: DashboardAccountRouteData.$parentNavigatorKey,
            ),
          ],
        ),
      ],
    );

extension $DashboardOAuthShellRouteDataExtension
    on DashboardOAuthShellRouteData {
  static DashboardOAuthShellRouteData _fromState(GoRouterState state) =>
      const DashboardOAuthShellRouteData();
}

extension $DashboardShellRouteDataExtension on DashboardShellRouteData {
  static DashboardShellRouteData _fromState(GoRouterState state) =>
      const DashboardShellRouteData();
}

extension $DashboardHomeRouteDataExtension on DashboardHomeRouteData {
  static DashboardHomeRouteData _fromState(GoRouterState state) =>
      const DashboardHomeRouteData();

  String get location => GoRouteData.$location(
        '/dashboard/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $DashboardAccountRouteDataExtension on DashboardAccountRouteData {
  static DashboardAccountRouteData _fromState(GoRouterState state) =>
      const DashboardAccountRouteData();

  String get location => GoRouteData.$location(
        '/dashboard/account',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}
