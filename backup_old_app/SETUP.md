# Autolab — Quick Setup Guide

Follow these steps after opening the project in a new GitHub Codespace.

---

## Step 1 — Download & Install Flutter

```bash
wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.4-stable.tar.xz -O /tmp/flutter.tar.xz
tar xf /tmp/flutter.tar.xz -C /workspaces/autolab-main/
```

## Step 2 — Add Flutter to PATH

```bash
export PATH="$PATH:/workspaces/autolab-main/flutter/bin"
echo 'export PATH="$PATH:/workspaces/autolab-main/flutter/bin"' >> ~/.bashrc
```

## Step 3 — Enable Web & Install Dependencies

```bash
cd /workspaces/autolab-main
flutter config --enable-web
flutter pub get
```

## Step 4 — Build & Run in Browser

```bash
flutter build web --release
cd build/web && python3 -m http.server 8080 --bind 0.0.0.0
```

## Step 5 — Open in Browser

1. Click the **Ports** tab at the bottom of VS Code
2. Find port **8080** → click the **globe icon** 🌐
3. The app opens in your browser

---

## Next Time (Codespace already set up)

Just run:
```bash
export PATH="$PATH:/workspaces/autolab-main/flutter/bin"
cd /workspaces/autolab-main/build/web && python3 -m http.server 8080 --bind 0.0.0.0
```
Then open port **8080** from the Ports tab.

> **Note:** If you make code changes, rebuild first:
> ```bash
> cd /workspaces/autolab-main && flutter build web --release
> ```
