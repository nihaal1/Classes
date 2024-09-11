#! /bin/bash

gcc -c secondary.c
gcc -c utilities.c
gcc -o receiver receiver.o secondary.o utilities.o ccitt16.o introduceerror.o

