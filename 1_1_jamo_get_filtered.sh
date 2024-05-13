#!/bin/bash

# PIDs are the shorter 7 digit project codes (e.g. 1290842)
# IDS are the longer 8 digit IMG analysis codes that always start 33000 (e.g. 3300045738)


PIDS=( `IFS=$'\n'; awk '{ print $2 }' "$1"` )
IDS=( `IFS=$'\n'; awk '{ print $1 }' "$1"` )

module add jamo

cd $PSCRATCH/mosaic_working_dirs

i=0

# run this three times:

# first jamo fetch -d 1 all spid $p - to retreive all files from tape
# then op=`jamo info filtered spid $p` - get path of filtered reads
# then op=`jamo info all apid $p | tr ' ' '\n' | grep -A 4 -B 1 'pairedMapped.sam.gz'`

# Alternative: this method then try
# jamo fetch -d 1 -w filtered apid $p followed by bbmap to get a samfile

for p in ${PIDS[@]}; do
    
    echo $p
    
    
    
    op=`jamo fetch -d 7 -w filtered spid $p`
    echo $op
    if [ "$op" = "No matching records found" ]; then
        echo "Trying same id with apid instead"
        op=`jamo fetch -d 7 -w filtered apid $p`
    fi
    echo $op
    op1=($op)
    filePath=${op1[0]}
    echo $filePath
    echo ${IDS[$i]}
    mkdir -p ${IDS[$i]}
    cp $filePath ./${IDS[$i]}
    
    gzip -d ./${IDS[$i]}/*.gz
    
    ((i=i+1))

done

