#!/usr/bin/expect --

spawn vncpasswd
sleep 1
expect "Password: "
sleep 1
send "$argv\r"
sleep 1
expect "Verify: "
sleep 1
send "$argv\r"
sleep 1
expect "$"

exit 0
