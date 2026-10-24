#!/bin/bash
# ==============================================================================
# CompAd - One-Click iOS Release & IPA Packager for Mac / iPhone
# ==============================================================================

set -e

echo "🚀 Starting CompAd iPhone Release Build..."

# Move to Flutter directory
cd "$(dirname "$0")/compad"

echo "📦 Fetching Flutter dependencies..."
flutter pub get

echo "🍏 Installing iOS CocoaPods..."
cd ios
pod install
cd ..

echo "🔨 Building iOS Release Bundle..."
flutter build ios --release --no-codesign

echo "📦 Packaging Standalone .IPA for iPhone Sideloading (AltStore / Sideloadly / TrollStore)..."
rm -rf Payload compad-iphone-release.ipa
mkdir -p Payload
cp -r build/ios/iphoneos/Runner.app Payload/
zip -r ../compad-iphone-release.ipa Payload
rm -rf Payload

echo "✅ SUCCESS! iPhone package generated at:"
echo "   $(pwd)/../compad-iphone-release.ipa"
