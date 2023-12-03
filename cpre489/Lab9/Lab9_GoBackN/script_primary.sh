#! /bin/bash

gcc -c primary.c
gcc -o sender sender.o primary.o utilities.o ccitt16.o introduceerror.o
