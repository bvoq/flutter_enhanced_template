#!/bin/sh

# In rare cases your pub cache needs to be cleared:
# flutter pub cache clean

# Make sure rosetta is installed:
softwareupdate --install-rosetta --agree-to-license

flutter clean
flutter pub get
flutter gen-l10n
flutter build ios
cd ios/
pod cache clean --all
flutter build ios --debug --flavor staging -t lib/main_staging.dart
flutter build macos --debug --flavor staging -t lib/main_staging.dart
#pod install
#pod update
cd ../
cd android
rm -r $HOME/.gradle/caches/
#rm -r $HOME/.android/cache/*
rm -r .gradle
#./gradlew cleanBuildCache
