#!/bin/bash
# ─────────────────────────────────────────────────────────────
# AutoLab Customer App - Dev Runner
#
# Usage:
#   bash run.sh          → runs web-server on port 8081 (open in browser)
#   bash run.sh android  → runs on Android device/emulator
#   bash run.sh build    → builds release APK
#   bash run.sh build-debug → builds debug APK
# ─────────────────────────────────────────────────────────────

set -e

export PATH="$PATH:/home/node/flutter-sdk/flutter/bin"
export CHROME_EXECUTABLE=/usr/bin/chromium

# Load .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | grep -v '^$' | xargs)
  echo "✅ Loaded .env"
else
  echo "⚠️  No .env found, using defaults"
  API_URL="https://zany-xylophone-6qwx9w6g9rc5g9x-3002.app.github.dev"
  WEB_PORT="8081"
fi

# Default port for customer app (different from flutter-app's 8080)
WEB_PORT="${WEB_PORT:-8081}"

echo "🔧 API_URL  = $API_URL"
echo "🌐 WEB_PORT = $WEB_PORT"
echo ""

TARGET=${1:-web}

case "$TARGET" in
  web)
    echo "🚀 Starting Customer App Web Server on port $WEB_PORT..."
    echo "   ➜ Open in browser: http://localhost:$WEB_PORT"
    echo "   ➜ In Codespace: use the Ports tab → port $WEB_PORT"
    echo ""
    flutter run \
      -d web-server \
      --web-port "$WEB_PORT" \
      --web-hostname 0.0.0.0 \
      --dart-define=API_URL="$API_URL"
    ;;

  android)
    echo "🤖 Starting Customer App on Android..."
    flutter run \
      -d android \
      --dart-define=API_URL="$API_URL"
    ;;

  build)
    echo "📦 Building release APK..."
    flutter build apk --release \
      --dart-define=API_URL="$API_URL"
    echo ""
    echo "✅ APK: build/app/outputs/flutter-apk/app-release.apk"
    ;;

  build-debug)
    echo "📦 Building debug APK..."
    flutter build apk --debug \
      --dart-define=API_URL="$API_URL"
    echo ""
    echo "✅ APK: build/app/outputs/flutter-apk/app-debug.apk"
    ;;

  *)
    echo "❌ Unknown target: $TARGET"
    echo "   Usage: bash run.sh [web|android|build|build-debug]"
    exit 1
    ;;
esac
