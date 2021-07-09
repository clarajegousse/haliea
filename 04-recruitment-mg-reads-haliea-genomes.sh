#!/bin/bash
#SBATCH --job-name=bowtie2
#SBATCH -p normal
#SBATCH --time=2-00:00:00
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
cd $WD
mkdir -p $WD/04-mapping

bowtie2-build $WD/01-halieaceae-dbs/haliea-genomes.fa $WD/04-mapping/haliea-genomes

for sample in `awk '{print $1}' $WD/data/metagenomes/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    # do the bowtie mapping to get the SAM file:
    bowtie2 --threads 12 \
            -x $WD/04-mapping/haliea-genomes \
            -1 $WD/01-qc-tara-metagenomes/$sample-QUALITY_PASSED_R1.fastq.gz \
            -2 $WD/01-qc-tara-metagenomes/$sample-QUALITY_PASSED_R2.fastq.gz \
            --no-unal \
            -S $WD/01-qc-tara-metagenomes/$sample.sam
done
