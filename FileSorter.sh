#! /usr/bin/env bash
cd files
ls -1 > .folders
while read entry; do
    cd $entry
    ../../ImageRotator.sh
    cd ..
done < .folders
rm * -d -f
cd ..
