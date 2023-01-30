#!/usr/local/bin/xonsh

def start_qemu():
    qemu-system-arm -M vexpress-a9 -m 32M -no-reboot -nographic -monitor telnet:127.0.0.1:1234,server,nowait -kernel /root/startup.bin