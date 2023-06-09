#!/bin/sh

# In rare cases your pub cache needs to be cleared:
# flutter pub cache clean

# Make sure rosetta is installed:
softwareupdate --install-rosetta --agree-to-license

flutter clean
flutter pub get
# generate internationalisations
flutter gen-l10n
# generate router.g.dart and other generated files.
dart run build_runner build --delete-conflicting-outputs
cd ios/
pod cache clean --all
# pod outdated
rm -rf Pods
rm Podfile.lock
pod repo update
pod update
pod install
flutter build ios --debug --flavor staging -t lib/main_staging.dart
flutter build macos --debug --flavor staging -t lib/main_staging.dart
cd ../
cd android
rm -r $HOME/.gradle
#rm -r $HOME/.android/cache/*
rm -r .gradle
#./gradlew cleanBuildCache
