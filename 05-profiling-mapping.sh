#!/bin/bash
#SBATCH --job-name=profiling
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

for sample in `awk '{print $1}' $WD/data/metagenomes/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi

    anvi-profile -c $WD/HALIEA-CONTIGS.db \
                 -i $WD/data/metagenomes/$sample.bam \
                 --profile-AA-frequencies \
                 --num-threads 12 \
                 -o $sample
done
