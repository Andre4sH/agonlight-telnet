# Agonlight Telnet Client
## Overview
This is a Telnet Client for the AgonLight 8-bit computer, written in BBC BASIC. It enables the AgonLight to establish Telnet connections through an ESP8266 module running ZiModem firmware. 

## Features
Connect to any Telnet server via IP and port.
Set custom configurations such as background color, text color, and verbosity.
Persistent configuration through an ini file (telnet.ini).
Command-line interface to interact with the user.
Debugging and verbose logging options for troubleshooting.

## Requirements
AgonLight 8-bit computer
ESP8266 module with ZiModem firmware.

## Installation
Flash the ZiModem firmware onto the ESP8266 if not already installed.
Connect the ESP8266 module to the AgonLight.
Load the Telnet client code onto the AgonLight.
Run the program on the AgonLight computer.
When prompted, enter a command such as:
open <ip address>: Opens a connection to the specified IP on port 23 (default).
open <ip address> <port>: Opens a connection to the specified IP and port.
set <Variable> <Value>: Set system variables like BGCOLOR, TEXTCOLOR, PORT, etc.
quit, bye, q: Exit the program.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

