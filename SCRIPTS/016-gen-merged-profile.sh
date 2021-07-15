#!/bin/bash
#SBATCH --job-name=merged-pro
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=016-gen-merged-profile.%j.out
#SBATCH --error=016-gen-merged-profile.%j.err

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD

anvi-merge $WD/PROFILES/*/PROFILE.db -o HALIEA-MERGED -c HALIEA-CONTIGS.db
