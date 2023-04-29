#!/bin/sh

# If adding windows, linux platform support, you need to enable:
# flutter pub add firebase_core_desktop

# Note: Multiple build features are actively in discussion:
# https://github.com/invertase/flutterfire_cli/issues/14
dart pub global activate flutterfire_cli 0.3.0-dev.16 --overwrite

# atm it generates local paths. TODO keep checking:
# https://github.com/invertase/flutterfire_cli/issues/14#issuecomment-1446680062
flutterfire update

# debug-symbols-ios is not used since we don't use: split-debug-info
# See: https://github.com/firebase/firebase-tools/issues/5291#issuecomment-1338479667
# And: https://docs.flutter.dev/deployment/obfuscate

# `Would you like your [iOS|macOS] GoogleService-Info.plist to be associated with your iOS Build configuration or Target (use arrow keys & space to select)?`
# > No, I want to write the file to the path I chose

flutterfire config \
  --project=dekeyser-d33a7 \
  --out=lib/firebase_options_development.dart \
  --android-package-name=ch.dekeyser.myapp \
  --ios-bundle-id=ch.dekeyser.myapp \
  --ios-out=ios/Runner/Configs/development/GoogleService-Info.plist \
  --no-debug-symbols-ios \
  --macos-bundle-id=ch.dekeyser.myapp \
  --macos-out=macos/Runner/Configs/development/GoogleService-Info.plist \
  --no-debug-symbols-macos \
  --platforms=ios,android,macos
#  --debug-symbols-ios
#  --android-out=android/app/src/development/google-services.json \

flutterfire config \
  --project=dekeyser-d33a7 \
  --out=lib/firebase_options_staging.dart \
  --android-package-name=ch.dekeyser.myapp \
  --ios-bundle-id=ch.dekeyser.myapp \
  --ios-out=ios/Runner/Configs/staging/GoogleService-Info.plist \
  --no-debug-symbols-ios \
  --macos-bundle-id=ch.dekeyser.myapp \
  --macos-out=macos/Runner/Configs/staging/GoogleService-Info.plist \
  --no-debug-symbols-macos \
  --platforms=ios,android,macos
#  --debug-symbols-ios
#  --android-out=android/app/src/staging/google-services.json \

flutterfire config \
  --project=dekeyser-d33a7 \
  --out=lib/firebase_options_production.dart \
  --android-package-name=com.juice.booster3 \
  --ios-bundle-id=ch.dekeyser.myapp \
  --ios-out=ios/Runner/Configs/production/GoogleService-Info.plist \
  --no-debug-symbols-ios \
  --macos-bundle-id=ch.dekeyser.myapp \
  --macos-out=macos/Runner/Configs/production/GoogleService-Info.plist \
  --no-debug-symbols-macos \
  --platforms=ios,android,macos
#  --debug-symbols-ios
#  --android-out=android/app/src/production/google-services.json \

bash prebuild_clean.sh
