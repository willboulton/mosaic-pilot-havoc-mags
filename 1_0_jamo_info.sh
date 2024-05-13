#!/bin/bash


PIDS=( `IFS=$'\n'; awk '{ print $2 }' "$1"` )
IDS=( `IFS=$'\n'; awk '{ print $1 }' "$1"` )

module add jamo

cd $PSCRATCH/mosaic_working_dirs

#cd $PSCRATCH/mosaic_project_files

i=0

# run this three times:

# first jamo fetch -d 1 all spid $p - to retreive all files from tape
# then op=`jamo info filtered spid $p` - get path of filtered reads
# then op=`jamo info all apid $p | tr ' ' '\n' | grep -A 4 -B 1 'pairedMapped.sam.gz'`

# Alternative if asaf doesn't like this method then try
# jamo fetch -d 1 -w filtered apid $p followed by bbmap to get a samfile

for p in ${PIDS[@]}; do
    
    echo $p
    
    
    
    #op=`jamo fetch -d 1 filtered spid $p`
    #echo $op
    #if [ "$op" = "No matching records found" ]; then
    #    echo "Trying same id with apid instead"
    #    op=`jamo fetch -d 1 filtered apid $p`
    #fi
    #echo $op
    #op1=($op)
    #filePath=${op1[0]}
    #echo $filePath
    #echo ${IDS[$i]}
    #mkdir -p ${IDS[$i]}
    #cp $filePath ./${IDS[$i]}
    
    #op=`jamo info all apid $p | tr ' ' '\n' | grep -A 4 -B 1 "${IDS[$i]}.tar.gz"`
    #if [ -z $op ]; then
    #    op=`jamo info all spid $p | tr ' ' '\n' | grep -A 4 -B 1 "${IDS[$i]}.tar.gz"`
    #fi
    
    #echo $op
    #op1=($op)
    #filePath=${op1[1]}
    #echo $filePath
    #echo ${IDS[$i]}
    #mkdir -p ${IDS[$i]}
    #cp $filePath ./${IDS[$i]}
    #cp $filePath ./
    #tar -xf ./${IDS[$i]}.tar.gz
    #rm ./${IDS[$i]}.tar.gz
    
    
    
    
    op=`jamo info all apid $p | tr ' ' '\n' | grep -A 4 -B 1 'pairedMapped.sam.gz'`
    if [ -z $op ]; then
        op=`jamo info all spid $p | tr ' ' '\n' | grep -A 4 -B 1 'pairedMapped.sam.gz'`
    fi
    
    echo $op
    op1=($op)
    filePath=${op1[1]}
    echo $filePath
    echo ${IDS[$i]}
    cp $filePath ./${IDS[$i]}
    gzip -d ./${IDS[$i]}/pairedMapped.sam.gz
    #rm ./${IDS[$i]}.tar.gz
    
    
    
    ((i=i+1))

done

#gzip -d -r ./*