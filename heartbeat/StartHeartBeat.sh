#!/bin/zsh

if [ -e $1 ] 
    then
        if [ -e $2 ]
            then
            mplayer "$2" -loop 0 -slave -quiet -input file="$1" &> /dev/null &
        else
            echo "no sound file"
        fi
    else
        mkfifo $1
        continue
fi



