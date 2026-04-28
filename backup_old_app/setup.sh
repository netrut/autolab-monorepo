#!/bin/bash
# ─────────────────────────────────────────────
#  Autolab — Full First-Time Setup
#  Run once in a new Codespace: bash setup.sh
# ─────────────────────────────────────────────
#chmod +x /workspaces/autolab-main/setup.sh
#./setup.sh

set -e  # stop on any error

FLUTTER_DIR="/workspaces/autolab-main/flutter"
FLUTTER_BIN="$FLUTTER_DIR/bin"
FLUTTER_VERSION="3.27.4"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Autolab Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Step 1 — Install Flutter if not present
if [ ! -f "$FLUTTER_BIN/flutter" ]; then
  echo ""
  echo "▶ Step 1/3  Downloading & Extracting Flutter $FLUTTER_VERSION..."
  wget -q --show-progress \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -O - | tar xJf - -C /workspaces/autolab-main/
  echo "            Flutter installed at $FLUTTER_DIR"
else
  echo ""
  echo "✓ Flutter already installed — skipping download"
fi

# Step 2 — Add to PATH for this session
export PATH="$PATH:$FLUTTER_BIN"

# Persist to .bashrc if not already there
if ! grep -q "$FLUTTER_BIN" ~/.bashrc; then
  echo "export PATH=\"\$PATH:$FLUTTER_BIN\"" >> ~/.bashrc
  echo "✓ Flutter PATH added to ~/.bashrc"
fi

# Step 2 — Enable web & install packages
echo ""
echo "▶ Step 2/3  Installing dependencies..."
cd /workspaces/autolab-main
flutter config --enable-web
flutter pub get

# Step 3 — Build for web
echo ""
echo "▶ Step 3/3  Building Flutter web app..."
flutter build web --release

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Setup complete!"
echo ""
echo "  Start the app anytime with:"
echo "     bash start.sh"
echo ""
echo "  Or open port 8080 from the Ports tab"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Auto-start server after setup
bash /workspaces/autolab-main/start.sh
