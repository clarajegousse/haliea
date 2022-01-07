#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD
mkdir -p $WD/MAPPING

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
	samtools idxstats $WD/DATA-SAMPLES/"$sample".bam | cut -f 1,3 > $WD/MAPPING/"$sample".tsv
done

scp -r -i ~/.ssh/id_rsa_ihpc cat3@garpur.ihpc.hi.is:/users/home/cat3/projects/haliea/MAPPING/ /Users/Clara/Projects/haliea
