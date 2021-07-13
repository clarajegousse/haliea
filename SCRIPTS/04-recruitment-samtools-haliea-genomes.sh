#!/bin/bash
#SBATCH --job-name=samtools
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD


for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi

	echo $sample
    # covert the resulting SAM file to a BAM file:
    samtools view -F 4 -bS $WD/DATA-SAMPLES/$sample.sam > $WD/DATA-SAMPLES/$sample-RAW.bam

    # sort and index the BAM file:
    samtools sort $WD/DATA-SAMPLES/$sample-RAW.bam -o $WD/DATA-SAMPLES/$sample.bam
    samtools index $WD/DATA-SAMPLES/$sample.bam

    # remove temporary files:
    #rm $WD/DATA-SAMPLES/$sample.sam $WD/DATA-SAMPLES/$sample-RAW.bam
done
