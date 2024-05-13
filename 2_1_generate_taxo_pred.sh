#!/bin/bash

while read -r file; do

    cd $PSCRATCH/mosaic_tmp/mmseqs/$file
    cat */f*.out1 > $file.taxo_pred
    echo "mmseqs completed, total lines: "
    wc -l $file.taxo_pred
    cp $file.taxo_pred $PSCRATCH/mosaic_project_files/$file/
    cd $PSCRATCH/mosaic_tmp/mmseqs/
    
done < $PSCRATCH/mosaic_tmp/taxo_pred_list_2.txt
