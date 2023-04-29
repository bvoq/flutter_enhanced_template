import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/firebase_options_development.dart'
    as firebase_options_development;
import 'package:myapp/router.dart';
import 'package:myapp/setup/pre_router_widget.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() async {
  debugPrint("Starting main_staging.dart (staging flavor).");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'firebase_options_development',
    options:
        firebase_options_development.DefaultFirebaseOptions.currentPlatform,
  );

  // always opt-in in stage.
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  if (kDebugMode) {
    stack_trace.Chain.capture(
      () {
        runApp(
          PreRouterWidget(
            initialRoute: Routes.dashboardAccount.path,
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
      PreRouterWidget(
        initialRoute: Routes.dashboardAccount.path,
      ),
    );
  }
}
