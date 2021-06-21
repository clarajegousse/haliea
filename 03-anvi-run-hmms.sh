#!/bin/bash
#SBATCH --job-name=hmm
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

CONTIGSDB="data/haliea-isolates/*.db"
for cdb in $CONTIGSDB
do
  echo "Processing $cdb ..."
  anvi-run-hmms -c $cdb -T 8 --also-scan-trnas
done
