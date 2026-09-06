#!/bin/bash

echo "========================================="
echo "Starting XRDP Docker Container"
echo "========================================="

# Khởi động D-Bus daemon
echo "[1/5] Starting D-Bus daemon..."
if [ -f /var/run/dbus/pid ]; then
    rm -f /var/run/dbus/pid
fi
dbus-daemon --system --fork
echo "D-Bus started."

# Khởi động PulseAudio
echo "[2/5] Starting PulseAudio..."
pulseaudio --start --system --disallow-exit --disable-shm 2>/dev/null || true
echo "PulseAudio started (or already running)."

# Tạo thư mục X11
echo "[3/5] Creating /tmp/.X11-unix..."
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

# Khởi động xrdp-sesman (session manager)
echo "[4/5] Starting xrdp-sesman..."
xrdp-sesman

# Khởi động xrdp
echo "[5/5] Starting xrdp on port 3389..."
xrdp

echo "========================================="
echo "✅ XRDP Server started successfully!"
echo "📌 Connect via RDP to: localhost:3389"
echo "🔑 Username: root | Password: root"
echo "========================================="

# Hiển thị log và giữ container chạy
tail -f /var/log/xrdp.log /var/log/xrdp-sesman.log
