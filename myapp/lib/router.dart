import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myapp/pages/future_waiting_page.dart';
import 'package:myapp/pages/loggedIn/dashboard/dashboard_account_page.dart';
import 'package:myapp/pages/loggedIn/dashboard/dashboard_home_page.dart';
import 'package:myapp/pages/loggedIn/dashboard/dashboard_page.dart';
import 'package:myapp/pages/loggedIn/login_shell.dart';
import 'package:myapp/pages/no_internet_page.dart';
import 'package:myapp/pages/welcome_page.dart';
import 'package:myapp/setup/pre_router_widget.dart';

part 'router.g.dart';

String _withRedirectQueryParameter({
  required String path,
  required String redirectUri,
}) {
  return '$path/?previouspath=${Uri.encodeFull(redirectUri)}';
}

/// [_lastExtra] is used to pass extra data from the redirect to the page.
/// This is used for the [noInternetScreen] or [futureWaiting] screen.
/// This is a workaround and changes to GoRouter might affect this setup.
/// Note that state.extra will keep having the item even on multiple redirects.
/// Only after resolving the final redirect is it cleared.
Object? _lastExtra;

/// [_rootNavigatorKey] is used to access the root navigator from routes. This means that if a route is pushed on a [ShellRoute]
/// which has the navigatorKey = _rootNavigatorKey, then the shell is not shown (rendered).
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Note: ShellRouter allows you to switch routes within a route, sharing UI elements.
// https://pub.dev/documentation/go_router/latest/go_router/ShellRoute-class.html
/*
final GlobalKey<NavigatorState> _dashboardShellNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _loggedInShellNavigatorKey =
    GlobalKey<NavigatorState>();
    */

GoRouter setupRouter(
  String initialLocation, {
  required PreRouterWidgetState? Function(BuildContext) getPreRouterWidgetState,
  Object? initialRouteExtra,
}) {
  // See: https://docs.flutter.dev/development/ui/navigation/url-strategies
  usePathUrlStrategy();

  // https://github.com/flutter/flutter/issues/99124
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,
    redirect: (context, state) async {
      _lastExtra = state.extra;
      debugPrint(
        "Redirecting to: ${state.location} with extra: ${state.extra} of type ${state.extra.runtimeType}",
      );

      // If we are on the welcome-, no internet- or force update screen, we don't want to redirect.
      if (state.location.startsWith(WelcomeRouteData.name) ||
          state.location.startsWith(NoInternetRouteData.name)) {
        return state.location;
      }
      // In case we don't have internet, we want to redirect to the no internet screen.
      final internetConnectivity =
          await InternetConnectionChecker().hasConnection;
      if (internetConnectivity == false) {
        debugPrint("No internet activity.");
        return _withRedirectQueryParameter(
          path: NoInternetRouteData.name,
          redirectUri: state.location,
        );
      }

      // In case there is a force update we want to redirect to the force update screen.
      /*
      final updateStrategy =
          await UpdateCheckerSingleton.getInstance().getUpdateStrategy();
      if (updateStrategy.updateStrategy.shouldShowForceUpdateScreen) {
        JuiceLogger.i("Force update detected.");
        return withRedirectQueryParameter(
          path: LoggedOutRoutes.forceUpdateScreen.path,
          redirectUri: updateStrategy.updateUrl ??
              UpdateCheckerSingleton.fallbackUpdateUrl,
        );
      }*/

      // Unknown route! We should never get here.
      // stderr.writeln("Unknown route access detected: ${state.location}");
      //debugPrint("Unknown route access detected: ${state.location}");
      return state.location;
    },
    routes: $appRoutes,
  );
  return router;
}

@TypedGoRoute<FutureWaitingRouteData>(
  path: FutureWaitingRouteData.path,
  name: FutureWaitingRouteData.name,
)
class FutureWaitingRouteData extends GoRouteData {
  const FutureWaitingRouteData({this.$extra});
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;
  static const String name = '/future_waiting';
  static const String path = '/future_waiting';

  final dynamic $extra;

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) {
    assert($extra != null);
    final extraArguments = $extra! as FutureWaitingExtra<Object>;
    //initialRouteExtra = null;
    return FutureWaitingPage<Object>(
      futureWaitingExtra: extraArguments,
    );
  }
}

@TypedGoRoute<NoInternetRouteData>(
  path: NoInternetRouteData.path,
  name: NoInternetRouteData.name,
)
class NoInternetRouteData extends GoRouteData {
  const NoInternetRouteData({this.previouspath});
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  static const String name = '/no_internet_screen';
  static const String path = '/no_internet_screen';

  final String? previouspath;

  @override
  MaterialPage<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    final Object? prevExtra = _lastExtra;

    return MaterialPage<void>(
      key: state.pageKey,
      child: NoInternetPage(
        onInternetConnectionAvailable: () {
          if (previouspath == null) {
            const WelcomeRouteData(environment: "bla")
                .go(_rootNavigatorKey.currentContext!);
          } else if (GoRouter.of(_rootNavigatorKey.currentContext!).canPop()) {
            GoRouter.of(_rootNavigatorKey.currentContext!).replace(
              previouspath!,
              extra: prevExtra,
            );
          } else {
            GoRouter.of(_rootNavigatorKey.currentContext!).go(
              previouspath!,
              extra: prevExtra,
            );
          }
        },
      ),
    );
  }
}

@TypedShellRoute<LoggedOutShellRouteData>(
  routes: [
    TypedGoRoute<WelcomeRouteData>(
      path: WelcomeRouteData.path,
      name: WelcomeRouteData.name,
    ),
  ],
)
class LoggedOutShellRouteData extends ShellRouteData {
  const LoggedOutShellRouteData();
  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  MaterialPage<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: Container(child: navigator),
    );
  }
}

class WelcomeRouteData extends GoRouteData {
  const WelcomeRouteData({required this.environment});
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      LoggedOutShellRouteData.$navigatorKey;
  static const String name = '/welcome';
  static const String path = '/welcome/:environment';

  final String environment;

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) {
    return const WelcomePage();
  }
}

@TypedShellRoute<LoginShellRouteData>(
  routes: [
    TypedShellRoute<DashboardShellRouteData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<DashboardHomeRouteData>(
          path: DashboardHomeRouteData.path,
          name: DashboardHomeRouteData.name,
        ),
        TypedGoRoute<DashboardAccountRouteData>(
          path: DashboardAccountRouteData.path,
          name: DashboardAccountRouteData.name,
        ),
      ],
    ),
  ],
)
class LoginShellRouteData extends ShellRouteData {
  const LoginShellRouteData();
  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  MaterialPage<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: LoginShell(
        shellChild: navigator,
      ),
    );
  }
}

class DashboardShellRouteData extends ShellRouteData {
  const DashboardShellRouteData();
  static final GlobalKey<NavigatorState> $navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  MaterialPage<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    final String loc = state.fullPath ?? "";
    int pageIndex = 0;
    if (loc.contains(DashboardHomeRouteData.name)) {
      pageIndex = 0;
    } else if (loc.contains(DashboardAccountRouteData.name)) {
      pageIndex = 1;
    }
    return MaterialPage<void>(
      key: state.pageKey,
      child: DashboardPage(
        pageIndex: pageIndex,
        child: navigator,
      ),
    );
  }
}

class DashboardHomeRouteData extends GoRouteData {
  const DashboardHomeRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      DashboardShellRouteData.$navigatorKey;

  static const String name = '/dashboard/home';
  static const String path = '/dashboard/home';

  @override
  MaterialPage<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: const DashboardHomePage(),
    );
  }
}

class DashboardAccountRouteData extends GoRouteData {
  const DashboardAccountRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      DashboardShellRouteData.$navigatorKey;

  static const String name = '/dashboard/account';
  static const String path = '/dashboard/account';

  @override
  MaterialPage<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: const DashboardAccountPage(),
    );
  }
}
