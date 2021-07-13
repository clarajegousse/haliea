#!/bin/bash
#SBATCH --job-name=bowtie2
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

salloc -N 1
ssh $SLURM_NODELIST
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

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    # do the bowtie mapping to get the SAM file:
    bowtie2 --threads 12 \
            -x $WD/04-mapping/haliea-genomes \
            -1 $WD/DATA-SAMPLES/$sample-QUALITY_PASSED_R1.fastq.gz \
            -2 $WD/DATA-SAMPLES/$sample-QUALITY_PASSED_R2.fastq.gz \
            --no-unal \
            -S $WD/DATA-SAMPLES/$sample.sam
done
