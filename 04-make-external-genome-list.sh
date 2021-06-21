#!/bin/bash

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD

touch external-genomes.txt
echo "name  contigs_db_path" >> external-genomes.txt

CONTIGSDB="data/cultivar-genomes/*.db"
for cdb in $CONTIGSDB
do
  spname=$(echo $cdb | cut -f 3 -d "/" | cut -f 1 -d ".")

  echo """$spname $cdb""" >> external-genomes.txt

done
