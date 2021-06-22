#!/bin/bash
#SBATCH --job-name=quality-filtering-of-raw-reads
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

iu-gen-configs $WD/data/samples.txt -o $WD/data/metagenomes
for sample in `awk '{print $1}' $WD/data/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
    iu-filter-quality-minoche $WD/data/metagenomes/$sample.ini --ignore-deflines
done
