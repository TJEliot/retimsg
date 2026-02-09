# retimsg

A mobile-friendly command-line chat interface for the [Reticulum](https://reticulum.network/) mesh networking protocol.

## Overview

retimsg provides a lightweight, terminal-based chat client designed to run on resource-constrained devices like OpenWrt routers. It enables encrypted messaging over Reticulum mesh networks with a simple command-line interface optimized for mobile terminals.

## Components

- **retimsg** - Interactive chat client for sending and receiving messages
- **retimsg-daemon** - Background service for message handling
- **retimsg-shell** - Restricted shell wrapper for SSH-only users
- **setup-autolaunch.sh** - Script to configure daemon autostart at boot

## Requirements

- Python 3
- Reticulum Network Stack (RNS)
- `inotify-simple` Python package

## Installation

### On OpenWrt

1. Install Python and dependencies:
```bash
opkg update
opkg install python3 python3-pip
pip3 install rns inotify-simple
```

2. Copy retimsg components to `/usr/local/bin/`:
```bash
# Make scripts executable
chmod +x retimsg retimsg-daemon retimsg-shell

# Copy to system location
cp retimsg retimsg-daemon retimsg-shell /usr/local/bin/
```

3. (Optional) Set up autolaunch:
```bash
cp setup-autolaunch.sh /root/
/root/setup-autolaunch.sh
```

### On Standard Linux

Same process, but use your distribution's package manager instead of `opkg`.

## Usage

### Interactive Client

Simply run:
```bash
retimsg
```

This launches the interactive chat interface. Use arrow keys for command history.

### Daemon Mode

Start the background daemon:
```bash
retimsg-daemon &
```

### Restricted Shell (SSH Users)

Configure SSH to automatically launch retimsg for specific users, preventing shell access while allowing messaging.

## Architecture Notes

retimsg is designed for OpenWrt environments, which have:
- Limited storage and memory
- Minimal command-line utilities (some standard Linux commands may be missing)
- Focus on networking/embedded use cases

The codebase avoids direct RNS imports in some components, instead communicating via sockets or shared message storage.

## Message Storage

Messages are stored locally as JSON files (location varies by configuration). These files are excluded from version control to maintain privacy.

## Development

This project was developed collaboratively with Claude (Anthropic) for use on OpenWrt mesh networking devices.

### Project Status

Active development. The relationship between `retimsg-shell` and `setup-autolaunch.sh` may have evolved - consult the code comments for current functionality.

## License

MIT License - see LICENSE file for details.

## Contributing

Pull requests welcome. This is a personal project but contributions that improve OpenWrt compatibility or mobile terminal UX are especially appreciated.


## TODO
- encrypt stored messages
- add announce functionality
- add the ability to view the announce stream
