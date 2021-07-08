#!/bin/bash
#SBATCH --job-name=download-sra-tara
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD/00-infos

cat $WD/00-infos/sra-accession.txt | while read -r acc
do
	echo $acc
	fastq-dump $acc  -v --outdir $WD/00-tara-metagenomes
done
