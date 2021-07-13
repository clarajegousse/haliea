#!/bin/bash
#SBATCH --job-name=quality-filtering-of-raw-reads
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/RAW-READS

iu-gen-configs samples-subset.txt -o $WD/DATA-SAMPLES

for sample in `awk '{print $1}' samples-subset.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
    iu-filter-quality-minoche $WD/DATA-SAMPLES/$sample.ini --ignore-deflines
	#gzip $WD/DATA-SAMPLES/$sample-QUALITY_PASSED_R1.fastq
	#gzip $WD/DATA-SAMPLES/$sample-QUALITY_PASSED_R2.fastq
done
