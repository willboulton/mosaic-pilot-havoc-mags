#!/bin/bash

MOSAIC_WORKING_DIRS=$CSCRATCH/mosaic_working_dirs

MOSAIC_TMP=$CSCRATCH/mosaic_tmp

ASSEMBLER_FOLDER=$MOSAIC_TMP/metaspades


# Generate the list of files we want to cat
sed 's|$|/euk_reads.fastq|g' $MOSAIC_TMP/bbmap_list.txt | \
    sed "s|^|$MOSAIC_WORKING_DIRS/|g" > $MOSAIC_TMP/cat_metaspades.txt

# Concatenate the files
cat $MOSAIC_TMP/cat_metaspades.txt | tr '\n' ' ' | xargs cat > $ASSEMBLER_FOLDER/all_euk_reads.fastq

# run metaspades
echo "Run metaspades"
shifter --image=bioboxes/spades:latest metaspades.py \
    --pe1-1 $ASSEMBLER_FOLDER/split_input/all_euk_reads_1.fastq \
    --pe1-2 $ASSEMBLER_FOLDER/split_input/all_euk_reads_2.fastq \
    --only-assembler \
    -o $ASSEMBLER_FOLDER

# replace --continue w/ --pe1-12 $MOSAIC_TMP/metaspades/all_euk_reads.fastq --assembly-only \
# To speed up more, replace with --pe1-1 $MOSAIC_TMP/metaspades/split_input/all_euk_reads_1.fastq etc. 

# bbmap generate a sorted bamfile for this set of reads
echo "Running bbmap"
shifter --image=bryce911/bbtools bbmap.sh \
    in=$ASSEMBLER_FOLDER/all_euk_reads.fastq \
    out=$ASSEMBLER_FOLDER/all_euk_reads.bam \
    ref=$ASSEMBLER_FOLDER/contigs.fasta nodisk

echo "Sorting bamfile"
shifter --image=robegan21/samtools:latest \
    samtools sort -o $ASSEMBLER_FOLDER/all_euk_reads.sorted.bam \
    -m 3G \
    $ASSEMBLER_FOLDER/all_euk_reads.bam


echo "Indexing bamfile"
shifter --image=robegan21/samtools:latest \
    samtools index $ASSEMBLER_FOLDER/all_euk_reads.sorted.bam
