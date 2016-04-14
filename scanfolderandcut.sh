#!/usr/bin/env bash

ls *.jpg > .tempfile

while read entry; do
    ~/noFacesForNames/cvFaceCutter/bin/cvFaceCutter $(pwd)/$entry
done < .tempfile

rm .tempfile
