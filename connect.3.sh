#!/usr/bin/env expect

# -----------------------------------------------------------------------------
# if it all goes pear shaped the script will timeout after 20 seconds.
set timeout 20
# first argument is assigned to the variable name
set name [lindex $argv 0]
puts "connecting: $name"

# exit
# second argument is assigned to the variable user
set user "ubnt"
# third argument is assigned to the variable password
set password "ubnt"
# fourth argument is file with commands to execute
set file_commands "commands.txt"

# -----------------------------------------------------------------------------
# load commands from commands-file
set f [open "$file_commands"]
set commands [split [read $f] "\n"]
close $f

# -----------------------------------------------------------------------------
# this spawns the telnet program and connects it to the variable name
spawn telnet $name 

expect "Trying"
expect "Connected"
expect "Escape character is '^]'."
expect ""
expect "User:"

# the script sends the user variable
send "$user\r"
# the script expects Password
expect "Password:"
# the script sends the password variable
send "$password\r"
# wait for the prompt
expect "(UBNT EdgeSwitch) >"

send "enable\r"
expect "(UBNT EdgeSwitch) #"


# -----------------------------------------------------------------------------
# iterate over the commands

set count 1;
set sleep 0.01;
while {$count > 0 } {
	puts "count : $count\n";
	set count [expr $count-1];


	foreach cmd $commands {
		send "$cmd\r"
		expect "(UBNT EdgeSwitch) #"
	}
	sleep $sleep
}

send "configure\r"
expect "(UBNT EdgeSwitch) (Config)#" 
send "interface 0/1-0/24\r"
expect "(UBNT EdgeSwitch) (Interface 0/1-0/24)#"


# -----------------------------------------------------------------------------
# close the connection
#send "quit\r"
#close

# -----------------------------------------------------------------------------
# instead of closing the connection, it would also be possible to hand the
# control over to the user by calling the following command:
interact
