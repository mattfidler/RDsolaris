#!/bin/sh
sshpass -p solaris ssh -p 3022 -oKexAlgorithms=+diffie-hellman-group1-sha1 rhub@127.0.0.1 -o forwardx11=yes 

