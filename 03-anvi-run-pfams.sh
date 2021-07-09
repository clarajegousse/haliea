#!/bin/bash
#SBATCH --job-name=pfams
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

CONTIGSDB="01-halieaceae-dbs/*.db"

for cdb in $CONTIGSDB
do
  if [ "$cdb" == "01-halieaceae-dbs/HALIEA-CONTIGS.db" ]; then continue; fi
  echo "Processing $cdb ..."
  anvi-run-pfams -c $cdb -T 8
done
