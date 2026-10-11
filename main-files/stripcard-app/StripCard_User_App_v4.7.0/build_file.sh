#!/bin/bash
set -e   # error হলে সাথে সাথে থেমে যাবে

# ==== Config ====
APP_NAME="Stripcard"
NEW_VERSION="v4.3.0"
PREVIOUS_VERSION="v4.2.0"

# ==== 1️⃣ Build APKs ====
flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi

# ==== 2️⃣ Prepare folder structure for APKs ====
mkdir -p "${APP_NAME}-app-${NEW_VERSION}/apk"
cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk \
   "${APP_NAME}-app-${NEW_VERSION}/apk/${APP_NAME}-armeabi-v7a.apk"
cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk \
   "${APP_NAME}-app-${NEW_VERSION}/apk/${APP_NAME}-arm64-v8a.apk"
#cp build/app/outputs/flutter-apk/app-x86_64-release.apk \
#   "${APP_NAME}-app-${NEW_VERSION}/apk/${APP_NAME}-x86_64.apk"

echo "✅ APKs copied to ${APP_NAME}-app-${NEW_VERSION}/apk"

# ==== 3️⃣ Flutter clean ====
flutter clean

# ==== 4️⃣ Copy full project (build cleaned) ====
mkdir -p "${APP_NAME}-app-${NEW_VERSION}/${APP_NAME}-app-new-${NEW_VERSION}"
rsync -av \
  --exclude '.git' \
  --exclude '.dart_tool' \
  --exclude '.gradle' \
  --exclude "${APP_NAME}-app-${NEW_VERSION}" \
  ./ \
  "${APP_NAME}-app-${NEW_VERSION}/${APP_NAME}-app-new-${NEW_VERSION}/"

# ==== 5️⃣ Copy only updated files: lib + pubspec.yaml ====
mkdir -p "${APP_NAME}-app-${NEW_VERSION}/${APP_NAME}-app-only-updated-files-${PREVIOUS_VERSION}-to-${NEW_VERSION}/lib"
cp -r lib/* \
   "${APP_NAME}-app-${NEW_VERSION}/${APP_NAME}-app-only-updated-files-${PREVIOUS_VERSION}-to-${NEW_VERSION}/lib/"
cp pubspec.yaml \
   "${APP_NAME}-app-${NEW_VERSION}/${APP_NAME}-app-only-updated-files-${PREVIOUS_VERSION}-to-${NEW_VERSION}/"

# ==== 6️⃣ Create zip archives ====
# 👉 One zip for full package (apks + full project + only-updated)
zip -r "${APP_NAME}-app-${NEW_VERSION}.zip" "${APP_NAME}-app-${NEW_VERSION}"

echo "✅ Done: ${APP_NAME}-app-${NEW_VERSION}.zip"
echo "✅ Done: ${APP_NAME}-app-${NEW_VERSION}/${APP_NAME}-app-new-${NEW_VERSION}.zip"
echo "✅ Done: ${APP_NAME}-app-${NEW_VERSION}/${APP_NAME}-app-only-updated-files-${PREVIOUS_VERSION}-to-${NEW_VERSION}.zip"