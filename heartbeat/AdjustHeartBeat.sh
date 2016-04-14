#!/bin/zsh

let VALUE=$1/100.0

if [ $1 -eq 0 ]
    then
        echo "quit 1" 
    else
        echo "speed $(echo $VALUE)" 
    fi
