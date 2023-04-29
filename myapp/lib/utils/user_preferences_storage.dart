import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// This class is responsible for persisting and retrieving user preferences.
class UserPreferencesStorage {
  UserPreferencesStorage([
    @visibleForTesting this.storage = const FlutterSecureStorage(),
  ]);

  static const String _applicationOverrideLanguageCodeStorageKey =
      'language.language_code';
  static const String _applicationOverrideCountryCodeStorageKey =
      'language.country_code';
  static const String _applicationThemeModeStorageKey = 'theme.mode';
  static const String _applicationThemeHighContrastStorageKey =
      'theme.high_contrast';
  static const String _applicationAnalyticsStorageKey = 'analytics.enabled';

  final FlutterSecureStorage storage;

  /// Returns the [Locale] of the application. If the locale is not set, returns `null`.
  Future<Locale?> readApplicationOverrideLocale() async {
    final String? languageCode =
        await storage.read(key: _applicationOverrideLanguageCodeStorageKey);
    final String? countryCode =
        await storage.read(key: _applicationOverrideCountryCodeStorageKey);
    if (languageCode == null) {
      return null;
    }
    return Locale(languageCode, countryCode);
  }

  /// Stores the [Locale] of the application.
  Future<void> storeApplicationOverrideLocale(Locale locale) async {
    await storage.write(
      key: _applicationOverrideLanguageCodeStorageKey,
      value: locale.languageCode,
    );
    await storage.write(
      key: _applicationOverrideCountryCodeStorageKey,
      value: locale.countryCode,
    );
  }

  /// Returns the [ThemeMode] of the application. If the theme is not set, returns [ThemeMode.system].
  Future<ThemeMode> readApplicationThemeMode() async {
    final String? themeMode =
        await storage.read(key: _applicationThemeModeStorageKey);

    switch (themeMode) {
      case 'ThemeMode.system':
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> storeApplicationThemeMode(ThemeMode themeMode) async {
    await storage.write(
      key: _applicationThemeModeStorageKey,
      value: themeMode.toString(),
    );
  }

  Future<bool?> readHighContrastEnabled() async {
    final String? highContrastString =
        await storage.read(key: _applicationThemeHighContrastStorageKey);
    switch (highContrastString) {
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        return null;
    }
  }

  Future<void> storeApplicationHighContrast({
    required bool highContrast,
  }) async {
    await storage.write(
      key: _applicationThemeHighContrastStorageKey,
      value: highContrast.toString(),
    );
  }

  Future<bool> readCrashlyticsEnabled() async {
    final String? crashlyticsEnabled =
        await storage.read(key: _applicationAnalyticsStorageKey);
    switch (crashlyticsEnabled) {
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        return true; // Default to crashlytics enabled.
    }
  }

  Future<void> storeCrashlyticsEnabled({
    required bool crashlyticsEnabled,
  }) async {
    await storage.write(
      key: _applicationAnalyticsStorageKey,
      value: crashlyticsEnabled.toString(),
    );
  }

  /// Removes all data from the secure storage
  Future<void> deleteEntireSecureStorage() async {
    await storage.deleteAll();
  }
}
