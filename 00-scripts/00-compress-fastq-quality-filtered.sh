#!/bin/bash
#SBATCH --job-name=compress
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1


echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/DATA-SAMPLES


for sample in `awk '{print $1}' samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
	gzip $WD/01-qc-tara-metagenomes/$sample-QUALITY_PASSED_R1.fastq
	gzip $WD/01-qc-tara-metagenomes/$sample-QUALITY_PASSED_R2.fastq
done
