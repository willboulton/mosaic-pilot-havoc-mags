#!/bin/bash

cd $PSCRATCH/mosaic_tmp/mmseqs

while read -r file; do

    mkdir -p $PSCRATCH/mosaic_tmp/mmseqs/$file

    $HOME/asaf_scripts/cmd_wrapper.pl \
        $PSCRATCH/mosaic_project_files/$file/$file.a.fna \
        10 $PSCRATCH/mosaic_tmp/mmseqs/$file/ 3 0 > ./$file/cmd1
        
    cd $PSCRATCH/mosaic_tmp/mmseqs/$file
    $HOME/asaf_scripts/slurm_a_cori.pl cmd1 mosaic_$file 10:00:00
    cd $PSCRATCH/mosaic_tmp/mmseqs
    
done < $PSCRATCH/mosaic_tmp/taxo_pred_list_2.txt