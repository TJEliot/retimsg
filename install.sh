#!/bin/sh
# Install retimsg to /usr/local/bin
cp retimsg retimsg-daemon retimsg-shell retimsg_utils.py /usr/local/bin/
chmod +x /usr/local/bin/retimsg /usr/local/bin/retimsg-daemon /usr/local/bin/retimsg-shell /usr/local/bin/retimsg_utils.py
echo "Installed to /usr/local/bin"
