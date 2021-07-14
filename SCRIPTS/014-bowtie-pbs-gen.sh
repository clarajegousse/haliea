#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/RAW-READS

#iu-gen-configs samples.txt -o $WD/DATA-SAMPLES

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
	echo '''#!/bin/bash
#SBATCH --job-name='$sample'-bowtie2
#SBATCH -p normal
#SBATCH --time=10:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME
source /users/home/cat3/.bashrc
conda activate anvio-master
WD=/users/home/cat3/projects/haliea
cd $WD/RAW-READS

bowtie2 --threads 7 \
-x $WD/HALIEA-genome \
-1 $WD/DATA-SAMPLES/'$sample'-QUALITY_PASSED_R1.fastq.gz \
-2 $WD/DATA-SAMPLES/'$sample'-QUALITY_PASSED_R2.fastq.gz \
--no-unal \
-S $WD/DATA-SAMPLES/'$sample'.sam
''' > $WD/DATA-SAMPLES/$sample'-bowtie-pbs.sh'
done
