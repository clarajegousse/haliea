#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/RAW-READS

#iu-gen-configs samples.txt -o $WD/DATA-SAMPLES

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
	echo '''#!/bin/bash
#SBATCH --job-name=qc-'$sample'
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output=004-qc-raw-reads-gen-pbs.%j.out
#SBATCH --error=004-qc-raw-reads-gen-pbs.%j.err

echo $HOSTNAME
source /users/home/cat3/.bashrc
conda activate anvio-master
WD=/users/home/cat3/projects/haliea
cd $WD/RAW-READS
iu-filter-quality-minoche $WD/DATA-SAMPLES/'$sample'.ini --ignore-deflines
''' > $WD/DATA-SAMPLES/$sample'-qc-pbs.sh'
done
