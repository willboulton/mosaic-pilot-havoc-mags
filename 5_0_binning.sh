#!/bin/bash

module add python

conda activate eukcc

MOSAIC_TMP=$CSCRATCH/mosaic_tmp

METABAT=$MOSAIC_TMP/metabat_havoc

# Summarise depth info for metabat

mkdir -p $METABAT/bins
mkdir -p $METABAT/bins_checked

cd $METABAT

/global/cfs/projectdirs/fnglanot/analysis/asalamov/SOFTWARE_BIO/metabat/jgi_summarize_bam_contig_depths \
    --outputDepth $METABAT/depth.txt \
    $MOSAIC_TMP/bamfiles_havoc/sorted/*.bam


# run metabat
shifter --image=metabat/metabat:latest metabat \
    -i $MOSAIC_TMP/metahipmer/mosaic_havoc_euks/final_assembly.fasta \
    -o bins/mbin \
    -a $METABAT/depth.txt


# eukcc will put its output into bins_checked (change --threads as necessary)
eukcc folder \
    --out bins_checked \
    --db $CSCRATCH/containers/eukccdb/eukcc2_db_ver_1.1 \
    --threads 16 \
    bins