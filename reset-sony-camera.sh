#!/bin/bash
# Reset Sony A6400 camera connection on macOS
# Force-kills the daemons that grab the PTP/USB connection and block Camera Live from seeing it

echo "🎥 Resetting Sony camera connection..."

# Kill Camera Live first so it releases any stale handle
killall -9 "Camera Live" 2>/dev/null && echo "✓ Killed Camera Live" || echo "  (Camera Live not running)"

# Force-kill ptpcamerad — grabs the Sony PTP connection
killall -9 ptpcamerad 2>/dev/null && echo "✓ Killed ptpcamerad" || echo "  (ptpcamerad not running)"

# Force-kill mscamerad-xpc — another daemon that holds PTP camera connections
killall -9 mscamerad-xpc 2>/dev/null && echo "✓ Killed mscamerad-xpc" || echo "  (mscamerad-xpc not running)"

# Force-kill VDCAssistant and UVCAssistant (may need sudo for these)
killall -9 VDCAssistant 2>/dev/null && echo "✓ Killed VDCAssistant" || echo "  (VDCAssistant not running or needs sudo)"
killall -9 UVCAssistant 2>/dev/null && echo "✓ Killed UVCAssistant" || echo "  (UVCAssistant not running or needs sudo)"

# Wait for daemons to respawn cleanly
echo ""
echo "⏳ Waiting for daemons to respawn..."
sleep 3

# Check if camera is visible on USB
echo ""
if /usr/sbin/ioreg -p IOUSB -w 0 | grep -q "ILCE-6400"; then
    echo "✅ Sony A6400 detected on USB!"
else
    echo "⚠️  Sony A6400 not found on USB — try unplugging and replugging the camera"
fi

# Relaunch Camera Live
echo ""
echo "🚀 Launching Camera Live..."
sleep 1
open "/Applications/Camera Live.app"

echo ""
echo "Done! Camera Live is restarting — give it a few seconds to detect the camera."
