#!/bin/bash

module add python

export SAMPLE_ID=$1



MOSAIC_WORKING_DIRS=$PSCRATCH/mosaic_working_dirs

if test -f "$MOSAIC_WORKING_DIRS/$SAMPLE_ID/euk_reads.fastq"; then
    echo "$MOSAIC_WORKING_DIRS/$SAMPLE_ID/euk_reads.fastq already exists, exiting."
    exit
fi

# the 2nd match of the @PG header (program) should be the end of the sam header. 
# After that the reads are listed one per line. Using -n on grep prints the line number which we extract. 
HEADER_END_LINE=`grep -n -m 2 "@PG" $MOSAIC_WORKING_DIRS/$SAMPLE_ID/pairedMapped.sam | tail -1 | tr ':' '\n' | head -1`

FASTQ_PATH=`echo $MOSAIC_WORKING_DIRS/$SAMPLE_ID/*.fastq | tail -1`





# Run the notebook to produce euk_scaffolds.taxo_pred.txt (list of euk scaffold ids)
jupyter nbconvert --to notebook --execute $HOME/notebooks/3_0_filter_fastq_for_euks.ipynb

echo "ran notebook, now filtering sam for euk_reads"

# Get read ids associated with euk scaffolds
# Exclude the header and print QNAME, RNAME, RNEXT fields in sam
# Filter for the euks in taxo_pred
sed 1,${HEADER_END_LINE}d $MOSAIC_WORKING_DIRS/$SAMPLE_ID/pairedMapped.sam | \
    awk -F'\t' '{print $1"\t"$3"\t"$7}' | \
    grep -f $MOSAIC_WORKING_DIRS/$SAMPLE_ID/euk_scaffolds.taxo_pred.txt | \
    awk -F'\t' '{ print $1 }' > $MOSAIC_WORKING_DIRS/$SAMPLE_ID/euk_reads.txt


echo "generated euk_reads.txt, now running filterbyname"

# Then use bbmap filterbyname.sh
shifter --image=bryce911/bbtools filterbyname.sh \
    in=$FASTQ_PATH \
    out=$MOSAIC_WORKING_DIRS/$SAMPLE_ID/euk_reads.fastq \
    names=$MOSAIC_WORKING_DIRS/$SAMPLE_ID/euk_reads.txt \
    include=t
