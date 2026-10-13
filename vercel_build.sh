#!/bin/bash
set -e

echo "=== [1/4] Downloading Flutter SDK (Shallow Clone) ==="
git clone https://github.com/flutter/flutter.git --depth 1 -b stable /tmp/flutter
export PATH="/tmp/flutter/bin:$PATH"

echo "=== [2/4] Verifying Flutter Environment ==="
flutter --version
flutter config --no-analytics --enable-web

echo "=== [3/4] Installing Sample Dependencies ==="
cd apps/sample
flutter pub get

echo "=== [4/4] Building Flutter Web for Production ==="
flutter build web --release --base-href /

echo "=== [SUCCESS] Web build complete in apps/sample/build/web ==="
