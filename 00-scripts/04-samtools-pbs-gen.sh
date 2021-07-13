#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/RAW-READS

#iu-gen-configs samples.txt -o $WD/01-qc-tara-metagenomes

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
	echo '''#!/bin/bash
#SBATCH --job-name='$sample'-samtools
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME
source /users/home/cat3/.bashrc
WD=/users/home/cat3/projects/haliea
cd $WD/01-qc-tara-metagenomes

samtools view -F 4 -bS $WD/01-qc-tara-metagenomes/'$sample'.sam > $WD/01-qc-tara-metagenomes/'$sample'-RAW.bam

# sort and index the BAM file:
samtools sort $WD/01-qc-tara-metagenomes/'$sample'-RAW.bam -o $WD/01-qc-tara-metagenomes/'$sample'.bam
samtools index $WD/01-qc-tara-metagenomes/'$sample'.bam

# remove temporary files:
#rm $WD/01-qc-tara-metagenomes/'$sample'.sam $WD/01-qc-tara-metagenomes/'$sample'-RAW.bam
''' > $WD/01-qc-tara-metagenomes/$sample'-samtools-pbs.sh'
done
