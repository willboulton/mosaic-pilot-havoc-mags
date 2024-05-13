#!/bin/bash
#SBATCH --job-name=mosaic_pilot_all_coassembly
#SBATCH --nodes=500
#SBATCH --qos=regular
#SBATCH -A m342
#SBATCH -C knl
#SBATCH --time=24:00:00
#SBATCH --export=ALL
#SBATCH --exclusive

module load MetaHipMer2/latest-knl

MOSAIC_TMP=$PSCRATCH/mosaic_tmp

OUTPUT_DIR=metahipmer_pilot_all

MHM_DIR=$MOSAIC_TMP/$OUTPUT_DIR

MOSAIC_WORKING_DIRS=$CSCRATCH/mosaic_working_dirs

INPUT_PROJECT_NAMES_FILE=pilot_coassembly_all_list.txt

EUK_OR_ALL=all

cd $MHM_DIR

while read -r f; do

    if test -f "$MHM_DIR/${f}.${EUK_OR_ALL}_reads.fastq"; then
    
        echo "$MHM_DIR/${f}.${EUK_OR_ALL}_reads.fastq already exists."
    else
    
        if [ EUK_OR_ALL == 'all' ]; then
        
            cp $MOSAIC_WORKING_DIRS/$f/5*.fastq $MHM_DIR/${f}.all_reads.fastq
            
        else
        
            cp $MOSAIC_WORKING_DIRS/$f/euk_reads.fastq $MHM_DIR/${f}.euk_reads.fastq
        fi
    fi
    
done < $MOSAIC_TMP/$INPUT_PROJECT_NAMES_FILE

EUK_READS_STR=$(cat $MOSAIC_TMP/$INPUT_PROJECT_NAMES_FILE | sed "s/$/.${EUK_OR_ALL}_reads.fastq/g"  | tr '\n' ' ')

echo "Starting Metahipmer"

mhm2.py -r $EUK_READS_STR -k 21,33,55,77,99 -o $OUTPUT_DIR --post-asm-align --post-asm-abd