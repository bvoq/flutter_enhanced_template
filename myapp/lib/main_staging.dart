import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/firebase_options_staging.dart'
    as firebase_options_staging;
import 'package:myapp/router.dart';
import 'package:myapp/setup/pre_router_widget.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() async {
  debugPrint("Starting main_staging.dart (staging flavor).");
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
    await Firebase.initializeApp(
      name: 'firebase_options_staging',
      options: firebase_options_staging.DefaultFirebaseOptions.currentPlatform,
    );

    // always opt-in in stage.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kReleaseMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  if (kDebugMode) {
    stack_trace.Chain.capture(
      () {
        runApp(
          const PreRouterWidget(
            initialRoute: DashboardAccountRouteData.path,
          ),
        );
      },
      onError: (Object error, stack_trace.Chain chain) {
        debugPrintSynchronously("Error: $error");
        debugPrintSynchronously("Stack trace: ${chain.terse}");
      },
    );
  } else {
    runApp(
      const PreRouterWidget(
        initialRoute: DashboardAccountRouteData.path,
      ),
    );
  }

  // Setup logging.
  /*
  JuiceLogger.setDisplaySettings(
    kHasEnabledConsoleLogging: true,
    kHasEnabledFirebaseLogging: true,
    kHasEnabledWidgetLogging: kDebugMode || Build.appFlavor != Flavor.prod,
  );
  */
  /*
  final Locale? applicationOverrideLocale = await UserPreferencesStorage().readApplicationOverrideLocale();
  final ThemeMode applicationThemeMode = await UserPreferencesStorage().readApplicationThemeMode();
  final bool applicationHighContrast = await UserPreferencesStorage().readHighContrastEnabled() ??
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).highContrast;
  final bool applicationCrashlytics = await UserPreferencesStorage().readCrashlyticsEnabled();

  final futureWaitingExtra = FutureWaitingExtra(
    // Attempt to load the old session and if it exists, go directly to the dashboard.
    future: MTLSWrapper().attemptToLoadKeycloakSessionFromStorage(),
    redirect: (Object completedFuture, BuildContext context) {
      if (completedFuture as bool) {
        final initialEnvironment = MTLSWrapper().oauth.authFlutterKeycloak!.environment;
        context.goNamed(
          LoggedInRoutes.dashboardHome.name,
          params: {'environment': initialEnvironment.toString()},
        );
      } else {
        context.goNamed(LoggedOutRoutes.welcome.name, params: {'environment': JuiceEnvironment.stage.name});
      }
    },
    onError: (Object? error, BuildContext context) {
      context.goNamed(LoggedOutRoutes.welcome.name, params: {'environment': JuiceEnvironment.stage.name});
    },
  );

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  if (kDebugMode) {
    stack_trace.Chain.capture(
      () {
        runApp(
          App(
            initialRoute: LoggedOutRoutes.futureWaiting.path,
            initialRouteExtra: futureWaitingExtra,
            initialLocale: applicationOverrideLocale,
            initialThemeMode: applicationThemeMode,
            initialHighContrast: applicationHighContrast,
            initialCrashlytics: applicationCrashlytics,
          ),
        );
      },
      onError: (Object error, stack_trace.Chain chain) {
        JuiceLogger.e("Error: $error");
        JuiceLogger.e("Stack trace: ${chain.terse}");
      },
    );
  } else {
    runApp(
      App(
        initialRoute: LoggedOutRoutes.futureWaiting.path,
        initialRouteExtra: futureWaitingExtra,
        initialLocale: applicationOverrideLocale,
        initialThemeMode: applicationThemeMode,
        initialHighContrast: applicationHighContrast,
        initialCrashlytics: applicationCrashlytics,
      ),
    );
  }
}
*/
}

//  static AppState? of(BuildContext context) => context.findAncestorStateOfType<AppState>();
