#!/usr/bin/env python3

import os
import signal
import sys

def main(args):
    kitty_pid = os.environ.get("KITTY_PID")
    if not kitty_pid:
        sys.exit(1)
    try:
        os.kill(int(kitty_pid), signal.SIGUSR1)
    except Exception:
        sys.exit(1)
