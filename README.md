# AgonLight Telnet Client

A telnet client written in **BBC BASIC for Z80** to run on the [AgonLight](https://www.thebyteattic.com/p/agon.html) computer.  
It uses an **ESP8266 with ZiModem firmware** as the modem interface to connect to remote telnet systems.

---

## ✨ Features
- Written entirely in **BBC BASIC** with inline Z80 assembly.
- Provides a simple **command-line interface** (`telnet>` prompt).
- Persistent **configuration file support** (`/.telnet.cfg`).
- Configurable:
  - Text and background colors
  - Default port (default: `23`)
  - Verbose/debug logging
- Built-in **address book** for frequently used connections.
- Basic **UART open, close, and send routines** in machine code for speed.
- Command-based interaction:
  - Open, close, continue sessions
  - View/set configuration
  - Save/apply settings
  
---

## 🛠 Requirements
- **AgonLight** computer
- **ESP8266** with [ZiModem firmware](https://github.com/bozimmerman/Zimodem)
- BBC BASIC for Z80

---

## 🚀 Getting Started

1. Flash your **ESP8266** with ZiModem.
2. Connect the ESP8266 to the AgonLight’s **UART**.
3. Load the BASIC program into AgonLight.
4. Run the client. You will see the `telnet>` prompt.

---

## 💻 Usage

At the `telnet>` prompt, you can type the following commands:

| Command                         | Description |
|---------------------------------|-------------|
| `open <ip>`                     | Open connection on default port (23). |
| `open <ip> <port>`              | Open connection on a specific port. |
| `#`                             | List address book entries. |
| `#<int>`                        | Connect to address book entry `<int>`. |
| `c` or `continue`               | Continue current session. |
| `close`                         | Close the current connection. |
| `config`                        | Show current configuration values. |
| `set <Variable> <Value>`        | Change system variable (see below). |
| `set`                           | List all system variables. |
| `apply`                         | Apply current config values. |
| `save`                          | Save config to file. |
| `quit`, `bye`, `q`              | Exit the client. |
| `help`                          | Show command help. |

### Variables you can configure

| Variable   | Description              | Valid Values |
|------------|--------------------------|--------------|
| `TEXTCOLOR`| Foreground text color    | Number |
| `BGCOLOR`  | Background color         | Number |
| `BELL`     | Enable/disable bell beep | `0` or `1` |
| `VERBOSE`  | Verbose mode             | `0` or `1` |
| `PORT`     | Default Telnet port      | Number |
| `DEBUG`    | Debug logging            | `0` or `1` |

---

## 📂 Configuration File
The client reads/writes settings from `/.telnet.cfg`.  
Example file contents:

BGCOLOR=4
TEXTCOLOR=6
VERBOSE=0
PORT=23
BELL=0
DEBUG=0

## 📖 Example Session

```text
Agonlight telnet client version: 0.1.0

telnet> #       (list address book)
1) Level 29

telnet> #1      (connect to address book entry 1)
Connecting to bbs.fozztexx.com:23

[remote BBS text appears here...]
