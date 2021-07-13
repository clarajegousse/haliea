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

mkdir -p $WD/PROFILES

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi

    anvi-profile -c HALIEA-CONTIGS.db \
                 -i $WD'/DATA-SAMPLES/'$sample'.bam' \
				 --profile-SCVs \
                 --num-threads 7 \
                 -o $WD'/PROFILES'/$sample -W
done
