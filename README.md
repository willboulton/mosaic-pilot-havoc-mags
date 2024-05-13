# Coassembly scripts for MOSAiC pilot and HAVOC MAGs

These scripts were run on the NERSC cluster. 

Step 1: run jamo_info.sh and unzip all files
We get all filtered fastq files (and .sam.gz alignments to contigs)

Use jamo_info.sh (multiple times with edits)

Output: mosaic_working_dirs/<SAMPLE_ID>/*.fastq and pairedMapped.sam

Use run_taxo_pred.sh to run mmseqs2 and generate_taxo_pred.sh
Input: control file is mosaic_tmp/taxo_pred_list.txt

Step 3: filter euk. reads
Use the notebook filter_fastq_for_euks.ipynb to generate a list of
eukaryotic contigs based off the taxo_pred file

Use bash utilities to get read ids from contigs, based on pairedMapped.sam
Then use bbmap filterbyname.sh (include=t)

Input: controlled by array job (mosaic_tmp/euk_reads_list.txt)
Output: mosaic_working_dirs/<SAMPLE_ID>/euk_reads.txt, euk_reads.fastq

Step 4: concatenate reads (cat) and generate contigs (MetaSPAdes or MetaHipMer)
Then, generate sorted bamfiles for each sample (euk reads only mapped to new contigs)

Input: List of sample ids needed to cat (at the moment, mosaic_tmp/bbmap_list.txt)
Output: mosaic_tmp/metaspades/all_euk_reads.fastq, .bam, .sorted.bam,
mosaic_tmp/bamfiles/<SAMPLE_ID>.euk.bam, mosaic_tmp/bamfiles/sorted/<SAMPLE_ID>.euk.sorted.bam

Step 5: generate metagenome bins - Asaf suggested concoct, also try metaBAT, VAMB. 
Evaluate completeness with eukcc.
Input: None, requires mosaic_tmp/bamfiles/sorted/
Output: mosaic_tmp/metabat/bins, bins_checked
