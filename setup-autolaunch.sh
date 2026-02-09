#!/bin/sh
#
# RetiMsg Auto-launch Setup
# Configures shell to launch retimsg on SSH login
#

set -e

PROFILE_FILE="$HOME/.profile"
MARKER_STRING="# RetiMsg Auto-launch"

echo "=== RetiMsg Auto-launch Setup ==="
echo ""

# Check if retimsg is installed
if [ ! -f "/usr/local/bin/retimsg" ]; then
    echo "Error: retimsg not found. Run install.sh first."
    exit 1
fi

# Check if already configured
if grep -q "$MARKER_STRING" "$PROFILE_FILE" 2>/dev/null; then
    echo "Error: RetiMsg auto-launch already configured in $PROFILE_FILE"
    echo "To reconfigure, first remove the existing RetiMsg section or restore from backup."
    exit 1
fi

# Backup existing profile if it exists
if [ -f "$PROFILE_FILE" ]; then
    cp "$PROFILE_FILE" "$PROFILE_FILE.backup"
    echo "✓ Backed up existing .profile to .profile.backup"
fi

# Create or append to .profile
cat >> "$PROFILE_FILE" << 'EOF'

# RetiMsg Auto-launch
# Automatically start retimsg on SSH login
if [ -n "$SSH_CONNECTION" ] && [ -t 0 ]; then
    # This is an interactive SSH session
    
    # Check if daemon is running, start if needed
    DAEMON_SOCK="$HOME/.retimsg/daemon.sock"
    if [ ! -S "$DAEMON_SOCK" ]; then
        echo "Starting RetiMsg daemon..."
        python3 /usr/local/bin/retimsg-daemon </dev/null >"$HOME/.retimsg/daemon.log" 2>&1 &
        sleep 2
    fi
    
    # Launch retimsg client
    echo ""
    echo "=== Welcome to RetiMsg ==="
    echo "Launching chat client..."
    echo ""
    retimsg
    
    # After retimsg exits, continue to normal shell
    echo ""
    echo "Exited retimsg. You now have a normal shell."
    echo "Type 'retimsg' to launch again, or 'exit' to disconnect."
fi
EOF

echo "✓ Added auto-launch configuration to $PROFILE_FILE"
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next time you SSH in, retimsg will launch automatically!"
echo ""
echo "To test now:"
echo "  1. Exit this SSH session"
echo "  2. SSH back in"
echo "  3. You should see retimsg launch automatically"
echo ""
echo "To disable auto-launch:"
echo "  Edit $PROFILE_FILE and remove the RetiMsg section"
echo "  Or restore backup: mv $PROFILE_FILE.backup $PROFILE_FILE"
