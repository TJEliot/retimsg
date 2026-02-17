# retimsg

A mobile-friendly command-line chat interface for the [Reticulum](https://reticulum.network/) mesh networking protocol. Designed specifically to work in mobile SSH terminal apps where richer interfaces like NomadNet don't function well.

## Overview

retimsg provides a lightweight, terminal-based chat client designed to run on resource-constrained devices like OpenWrt routers. It enables encrypted messaging over Reticulum mesh networks with a simple command-line interface optimized for mobile terminals.

## Architecture

retimsg uses a client-daemon architecture:

- **retimsg** (client) - Terminal UI that communicates with the daemon via Unix socket. Does not directly import Reticulum/LXMF.
- **retimsg-daemon** - Background service that handles all Reticulum/LXMF operations, receives messages, queues outgoing messages.

This separation allows the client to remain lightweight and responsive while the daemon handles network operations.

## Components

- **retimsg** - Interactive chat client for sending and receiving messages
- **retimsg-daemon** - Background service for Reticulum/LXMF message handling
- **retimsg-shell** - Restricted shell wrapper that ensures daemon is running and launches client (prevents shell escape for SSH-only users)
- **setup-autolaunch.sh** - Modifies `.profile` to auto-launch retimsg on SSH login (provides convenience but allows normal shell access afterward)

## Requirements

- Python 3
- Reticulum Network Stack (`rns`) and LXMF (`lxmf`) - required by daemon only
- `inotify-simple` Python package - required by client only

## Installation

### On OpenWrt

1. Install Python and dependencies:
```bash
opkg update
opkg install python3 python3-pip
pip3 install rns lxmf inotify-simple
```

2. Install retimsg components to `/usr/local/bin/`:
```bash
./install.sh
```

3. (Optional) Start the daemon manually to verify it works:
```bash
retimsg-daemon &
# Check log if it doesn't start:
cat ~/.retimsg/daemon.log
```

4. (Optional) Set up autolaunch for convenience:
```bash
cp setup-autolaunch.sh /root/
/root/setup-autolaunch.sh
```

5. (Optional) Set up restricted shell for SSH-only users:
```bash
# Edit /etc/passwd and change the user's shell to /usr/local/bin/retimsg-shell
# This prevents shell access while allowing retimsg usage
```

### On Standard Linux

Same process, but use your distribution's package manager instead of `opkg`.

## Usage

### Starting the Daemon

The daemon must be running before using the client:
```bash
retimsg-daemon &
```

The daemon will:
- Create identity if needed at `~/.reticulum/identities/$USER`
- Listen for messages on the Reticulum network
- Create Unix socket at `~/.retimsg/daemon.sock` for client communication
- Log to `~/.retimsg/daemon.log`

### Interactive Client

Once daemon is running:
```bash
retimsg
```

On first launch retimsg will display **your LXMF address** — share this with anyone who wants to message you. Then either enter a contact's hash to start a conversation, or use `/switch <hash>` if you already have one.

The client supports arrow keys and command history via readline.

### Commands

| Command | Description |
|---|---|
| `/list` | Show recent conversations |
| `/switch <number\|name\|hash>` | Switch to a conversation (number from `/list`, nickname, or full hash) |
| `/name <nickname>` | Give the current contact a nickname |
| `/name <hash> <nickname>` | Give any contact a nickname |
| `/show` | Display all messages in the current conversation |
| `/check` | Manually check for new messages |
| `/help` | Show in-app help including your LXMF address |

New messages appear automatically without polling — the client watches `messages.jsonl` via inotify.

### Contacts / Nicknames

Nicknames are stored in `~/.retimsg/contacts.json`. Once you assign a nickname with `/name`, it appears everywhere in place of the raw hash.

### Checking Daemon Status

If the client reports the daemon isn't running:
```bash
# Check if socket exists
ls -la ~/.retimsg/daemon.sock

# Check daemon log for errors
cat ~/.retimsg/daemon.log

# Restart daemon if needed
retimsg-daemon &
```

## Message Storage

Messages are stored at `~/.retimsg/messages.jsonl` in JSON Lines format. Each line is a complete JSON object representing one message. These files are excluded from version control to maintain privacy.

## OpenWrt Compatibility Notes

retimsg is designed for OpenWrt environments, which have:
- Limited storage and memory
- Minimal command-line utilities (some standard Linux commands may be missing)
- Focus on networking/embedded use cases

The client-daemon split helps minimize resource usage - the client is a lightweight Python script while the daemon handles all network operations.

## Development

This project was developed collaboratively with Claude (Anthropic) for use on OpenWrt mesh networking devices.

### Project Status

Active development. The codebase is functional but improvements are ongoing.

## License

MIT License - see LICENSE file for details.

## Contributing

Pull requests welcome. This is a personal project but contributions that improve OpenWrt compatibility or mobile terminal UX are especially appreciated.

## TODO

- Encrypt stored messages (currently stored as plain JSON)
- Add announce functionality (broadcast presence on Reticulum network)
- Add the ability to view the announce stream (see who's online)
- Add proper error handling for daemon crashes / restart logic
