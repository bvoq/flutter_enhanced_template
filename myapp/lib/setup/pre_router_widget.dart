import 'dart:io' show Platform;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/router.dart';
import 'package:myapp/theme.dart';
import 'package:myapp/utils/user_preferences_storage.dart';

class PreRouterWidget extends StatefulWidget {
  const PreRouterWidget({
    required this.initialRoute,
    this.initialRouteExtra,
    super.key,
  });

  final String initialRoute;
  final Object? initialRouteExtra;

  static PreRouterWidgetState? of(BuildContext context) =>
      context.findAncestorStateOfType<PreRouterWidgetState>();

  @override
  PreRouterWidgetState createState() => PreRouterWidgetState();
}

class PreRouterWidgetState extends State<PreRouterWidget> {
  final UserPreferencesStorage _userPreferences = UserPreferencesStorage();
  late final GoRouter _router;
  late ThemeMode _localThemeMode;
  Locale? _localeOverride;
  late bool _localHighContrast;
  late bool _localCrashlytics;

  @override
  void initState() {
    super.initState();
    debugPrint(
      "Starting app with initial route ${widget.initialRoute}.",
    );
    // TODO(bvoq): load from secure storage.
    _localeOverride = null;
    _localThemeMode = ThemeMode.system;
    _localHighContrast =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).highContrast;
    _localCrashlytics = true;

    if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
      FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(_localCrashlytics);
    }

    _router = setupRouter(
      widget.initialRoute,
      initialRouteExtra: widget.initialRouteExtra,
      getPreRouterWidgetState: (BuildContext context) =>
          PreRouterWidget.of(context),
    );
  }

  Locale? getLocale() => _localeOverride;
  Future<void> setLocale(Locale newLocale) async {
    debugPrint("Manually changing locale to $newLocale");
    await _userPreferences.storeApplicationOverrideLocale(newLocale);

    setState(() {
      _localeOverride = newLocale;
    });
  }

  ThemeMode getTheme() => _localThemeMode;
  Future<void> setTheme(ThemeMode themeMode) async {
    debugPrint("Setting theme to $themeMode.");
    await _userPreferences.storeApplicationThemeMode(themeMode);
    setState(() {
      _localThemeMode = themeMode;
    });
  }

  bool getHighContrast() => _localHighContrast;
  Future<void> setHighContrast({required bool highContrast}) async {
    debugPrint("Setting highContrast to $highContrast.");
    await _userPreferences.storeApplicationHighContrast(
      highContrast: highContrast,
    );
    setState(() {
      _localHighContrast = highContrast;
    });
  }

  bool getCrashlyticsEnabled() => _localCrashlytics;
  Future<void> setCrashlyticsEnabled({required bool crashlyticsEnabled}) async {
    debugPrint("Setting crashlyticsEnabled to $crashlyticsEnabled.");
    await _userPreferences.storeCrashlyticsEnabled(
      crashlyticsEnabled: crashlyticsEnabled,
    );
    if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(crashlyticsEnabled);
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
    setState(() {
      _localCrashlytics = crashlyticsEnabled;
    });
  }

  Future<void> deleteAll() async {
    debugPrint("Manually resetting locale to system default.");
    await _userPreferences.deleteEntireSecureStorage();
    setState(() {
      _localeOverride = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Makes the app portrait only for Android and IPhones
    // For IPads this setting is not applied
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp.router(
      theme: _localHighContrast ? highcontrastLightTheme : lightTheme,
      darkTheme: _localHighContrast ? highcontrastDarkTheme : darkTheme,
      highContrastTheme:
          null, // has to be null, otherwise it will be based on system brightness.
      highContrastDarkTheme:
          null, // has to be null, otherwise it will be based on system brightness.
      themeMode: _localThemeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
      locale: _localeOverride,
    );
  }
}
