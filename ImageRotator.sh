#!/usr/bin/env bash
ls *.json -1 | cut -f 1 -d '.' > .listofmetafiles
ls *.jpg -1 | cut -f 1 -d '.' > .listofimages
grep -f .listofimages .listofmetafiles -v | sed -e 's/$/.meta.json/' | xargs rm -f
echo "deleted bad files"
rm .listofimages
ls *.json -1 > .listofmetafiles 
while read entry; do grep acc_data $entry | cut -c 28- | cut -f 1 -d ']' | sed -e 's/,//;s/, / /' ; done < .listofmetafiles > .listofacceldata
nl -nrz .listofacceldata > .listofacceldatanew  
cat .listofacceldatanew > .listofacceldata
rm .listofacceldatanew
nl -nrz .listofmetafiles > .listofmetafilesnew
cat .listofmetafilesnew > .listofmetafiles
rm .listofmetafilesnew
join .listofmetafiles .listofacceldata > .listoffiles
echo "made lists"
cut -d ' ' -f 3 .listoffiles > .xvalues 
while read entry; do 
    if [ $entry -lt -800 ];
        then 
            echo '0';
        else 
        echo '-90>'; 
    fi
done < .xvalues > .xvaluesnew 
nl -nrz .xvaluesnew > .xvalues
rm .xvaluesnew
join .listoffiles .xvalues > .listoffilesnew
echo "added xvalues to list"
cat .listoffilesnew > .listoffiles
rm .listoffilesnew .xvalues .listofmetafiles .listofacceldata
while read entry; do
    echo "$entry" > .tempfile
    FILE=$(cut -d ' ' -f 2 .tempfile | cut -d '.' -f 1 | sed -e 's/$/&.jpg/')
    DATAFILE=$(cut -d ' ' -f 2 .tempfile)
    if [ "$(cut -d ' ' -f 6 .tempfile)" == "-90>" ];
    then
        convert $FILE -rotate "-90>" $FILE;
    fi
    rm $DATAFILE
done < .listoffiles
rm .listoffiles .tempfile
echo "complete $(printf '%s\n' "${PWD##*/}")" 
