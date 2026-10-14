#!/bin/bash

echo "=== Linux System Health Check ==="
echo ""
echo "Current user: $(whoami)"
echo ""
echo "=== CPU ==="
echo "Uptime: $(uptime)"
echo ""
echo "=== MEMORY ==="
free -h
echo ""
echo "=== DISK ==="
df -h /
echo ""
servis_kontrol() {
    if systemctl is-active --quiet "$1"; then
        echo "[OK] $1 çalışıyor."
    else
        echo "[ERROR] $1 çalışmıyor."
    fi
}

dosya_kontrol() {
    if [ -f "$1" ]; then
        echo "[OK] $1."
    else
        echo "[ERROR] $1."
    fi
}

echo "=== SERVICES ==="
servis_kontrol nginx
echo ""
echo "=== FILES ==="
echo ""
for file in /etc/hosts /etc/passwd /olmayan-dosya.txt; do
    dosya_kontrol "$file"
done
echo ""
echo "=== Check Completed ==="
echo ""


