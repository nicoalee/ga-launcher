#!/usr/bin/python3
import socket
s = socket.socket()
s.bind(('', 0))            # Bind to a free port provided by the host.
print(s.getsockname()[1])
