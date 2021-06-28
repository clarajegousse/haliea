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

bowtie2-build haliea-genomes.fa haliea-genomes

for sample in `awk '{print $1}' $WD/data/metagenomes/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    # do the bowtie mapping to get the SAM file:
    bowtie2 --threads 12 \
            -x haliea-genomes \
            -1 $WD/data/metagenomes/$sample-QUALITY_PASSED_R1.fastq \
            -2 $WD/data/metagenomes/$sample-QUALITY_PASSED_R2.fastq \
            --no-unal \
            -S $WD/data/metagenomes/$sample.sam

    # covert the resulting SAM file to a BAM file:
    samtools view -F 4 -bS $WD/data/metagenomes/$sample.sam > $WD/data/metagenomes/$sample-RAW.bam

    # sort and index the BAM file:
    samtools sort $WD/data/metagenomes/$sample-RAW.bam -o $WD/data/metagenomes/$sample.bam
    samtools index $WD/data/metagenomes/$sample.bam

    # remove temporary files:
    #rm $WD/data/metagenomes/$sample.sam $WD/data/metagenomes/$sample-RAW.bam
done
