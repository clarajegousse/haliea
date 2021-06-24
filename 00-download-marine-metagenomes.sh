#!/usr/bin/env bash
#SBATCH --job-name=download-marine-mg
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME

# set working directory
WD=/users/home/cat3/projects/haliea

cd $WD/data/metagenomes
for url in `cat ../ftp-links-for-raw-data-files2.txt`
do
    wget $url
done
