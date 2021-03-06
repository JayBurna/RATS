#!/bin/sh
# A small bash script to fire off many of my common enumeration/scanning tools with one command.  Use is fairly straight-forward.
# To-Do:
# - Add SQLMap and Hydra commands.
# - Add some sort of menu or choice type system to run or not run certain scans when run.
# - Make a sandwich.
# -- likwidsec --
#
# -- 10/27/17 -- Now the script takes 1 argument - the host.  No more editing every time.

HOST=$1
WFUZZWL="/usr/share/wordlists/wfuzz/general/big.txt"
WORDLIST="/usr/share/wordlists/dirbuster/dir-medium.txt" # -- CHANGE THIS IF NEEDED
USERLIST="/usr/share/wordlists/metasploit/unix_users.txt"
PASSLIST="/usr/share/wordlists/rockyou.txt"

#nmap -
nmap -T3 -A --reason --privileged -vv -oA nmap.$HOST $HOST &

#wpscan -
wpscan --enumerate --url http://$HOST/ > wpscan.$HOST &

#wfuzz -
wfuzz -c -z file,$WFUZZWL --hc 404,500 http://$HOST/FUZZ > wfuzz.$HOST &

#gobuster -
gobuster -w $WORDLIST -u http://$HOST > gobuster.$HOST &

#dirb -
dirb http://$HOST $WORDLIST -w -r > dirb.$HOST &

#uniscan -
uniscan -u http://$HOST/ -qweds > uniscan.$HOST &

#nikto -
nikto -h $HOST -Cgidirs all -ask auto > nikto.$HOST &
