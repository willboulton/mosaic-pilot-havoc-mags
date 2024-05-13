#!/bin/bash

SAMPLE_ID=$1

MOSAIC_WORKING_DIRS=$PSCRATCH/mosaic_working_dirs
MOSAIC_TMP=$PSCRATCH/mosaic_tmp

MOSAIC_BAMFILES=$MOSAIC_TMP/bamfiles_havoc

INFILE=$MOSAIC_WORKING_DIRS/$SAMPLE_ID/euk_reads.fastq

OUTFILE=$MOSAIC_BAMFILES/$SAMPLE_ID.euk.bam

REF=$MOSAIC_TMP/metahipmer/mosaic_havoc_euks/final_assembly.fasta

SORTED_OUTFILE=$MOSAIC_BAMFILES/sorted/$SAMPLE_ID.euk.sorted.bam

mkdir -p $MOSAIC_BAMFILES/sorted

echo "Running bbmap, using the following files: "
echo $INFILE $OUTFILE $REF

shifter --image=bryce911/bbtools bbmap.sh \
    in=$INFILE \
    out=$OUTFILE \
    ref=$REF nodisk

echo "Sorting bamfile"
shifter --image=robegan21/samtools:latest \
    samtools sort -o $SORTED_OUTFILE -m 3G $OUTFILE


echo "Indexing bamfile"
shifter --image=robegan21/samtools:latest \
    samtools index $SORTED_OUTFILE