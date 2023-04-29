import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myapp/pages/dashboard/dashboard_account_page.dart';
import 'package:myapp/pages/dashboard/dashboard_home_page.dart';
import 'package:myapp/pages/dashboard/dashboard_page.dart';
import 'package:myapp/pages/future_waiting_page.dart';
import 'package:myapp/pages/no_internet_page.dart';
import 'package:myapp/pages/welcome_page.dart';
import 'package:myapp/setup/pre_router_widget.dart';

enum Routes {
  // We need to have a welcome route for each environment, because on app start we have to default to the one set
  // in the build config / build flavor.
  welcome("/welcome/:environment", "/welcome"),
  futureWaiting("/future_waiting", "/future_waiting"),
  noInternetScreen("/no_internet_screen", "/no_internet_screen"),
  debugRoute("/debug_route/:debug_parameter", "/debug_route"),
  dashboardAccount("/dashboard/account", "/dashboard/account"),
  dashboardHome("/dashboard/home", "/dashboard/home");

  const Routes(this.path, this.name);

  final String path;
  final String name;

  static bool contains(String route) {
    return Routes.values.any((r) => route.startsWith(r.name));
  }
}

String _withRedirectQueryParameter({
  required String path,
  required String redirectUri,
}) {
  return '$path/?redirect=${Uri.encodeFull(redirectUri)}';
}

/// [_lastExtra] is used to pass extra data from the redirect to the page.
/// This is used for the [Routes.noInternetScreen] or [Routes.futureWaiting] screen.
/// This is a workaround and changes to GoRouter might affect this setup.
/// Note that state.extra will keep having the item even on multiple redirects.
/// Only after resolving the final redirect is it cleared.
Object? _lastExtra;

/// [_rootNavigatorKey] is used to access the root navigator from routes. This means that if a route is pushed on a [ShellRoute]
/// which has the navigatorKey = _rootNavigatorKey, then the shell is not shown (rendered).
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Note: ShellRouter allows you to switch routes within a route, sharing UI elements.
// https://pub.dev/documentation/go_router/latest/go_router/ShellRoute-class.html
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

GoRouter setupRouter(
  String initialLocation, {
  Object? initialRouteExtra,
  required PreRouterWidgetState? Function(BuildContext) getPreRouterWidgetState,
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
      if (state.location.startsWith(Routes.welcome.name) ||
          state.location.startsWith(Routes.noInternetScreen.name)) {
        return state.location;
      }
      // In case we don't have internet, we want to redirect to the no internet screen.
      final internetConnectivity =
          await InternetConnectionChecker().hasConnection;
      if (internetConnectivity == false) {
        debugPrint("No internet activity.");
        return _withRedirectQueryParameter(
          path: Routes.noInternetScreen.name,
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

      // Possibly seperate into LoggedInRoutes and LoggedOutRoutes.
      if (Routes.contains(state.location)) {
        return state.location;
      }

      // Unknown route! We should never get here.
      // stderr.writeln("Unknown route access detected: ${state.location}");
      debugPrint("Unknown route access detected: ${state.location}");
      return state.location;
    },
    routes: [
      // welcome
      GoRoute(
        name: Routes.welcome.name,
        path: Routes.welcome.path,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          // param = state.params['param']!;
          return MaterialPage<void>(
            key: state.pageKey,
            child: const WelcomePage(),
          );
        },
      ),
      // futureWaiting
      GoRoute(
        name: Routes.futureWaiting.name,
        path: Routes.futureWaiting.path,
        //parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          assert(state.extra != null || initialRouteExtra != null);
          final extraArguments =
              (state.extra ?? initialRouteExtra)! as FutureWaitingExtra<Object>;
          initialRouteExtra = null;

          return MaterialPage<void>(
            key: state.pageKey,
            child: FutureWaitingPage<Object>(
              futureWaitingExtra: extraArguments,
            ),
          );
        },
      ),
      // noInternetScreen
      GoRoute(
        name: Routes.noInternetScreen.name,
        path: Routes.noInternetScreen.path,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final String? prevPath = state.queryParams['redirect'];
          final Object? prevExtra = _lastExtra;

          return MaterialPage<void>(
            key: state.pageKey,
            child: NoInternetPage(
              onInternetConnectionAvailable: () {
                if (prevPath == null) {
                  GoRouter.of(_rootNavigatorKey.currentContext!).goNamed(
                    Routes.welcome.name,
                  );
                } else if (GoRouter.of(_rootNavigatorKey.currentContext!)
                    .canPop()) {
                  GoRouter.of(_rootNavigatorKey.currentContext!).replace(
                    prevPath,
                    extra: prevExtra,
                  );
                } else {
                  GoRouter.of(_rootNavigatorKey.currentContext!).go(
                    prevPath,
                    extra: prevExtra,
                  );
                }
              },
            ),
          );
        },
      ),

      // dashboardPage
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return DashboardPage(child: child);
        },
        routes: [
          // dashboardHome
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: Routes.dashboardHome.name,
            path: Routes.dashboardHome.path,
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const DashboardHomePage(),
              );
            },
          ),
          // dashboardAccount
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: Routes.dashboardAccount.path,
            name: Routes.dashboardAccount.name,
            pageBuilder: (context, state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: DashboardAccountPage(
                  getPreRouterWidgetState: getPreRouterWidgetState,
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
  return router;
}
