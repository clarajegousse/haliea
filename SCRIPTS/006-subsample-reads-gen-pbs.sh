#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/DATA-SAMPLES

for sample in `ls | grep "extendedFrags.fastq.gz" | cut -f 1 -d "."`
do
    if [ "$sample" == "sample" ]; then continue; fi
	echo $sample
	echo '''#!/bin/bash
#SBATCH --job-name=subsample-'$sample'
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output='$sample'-subsample-pbs.%j.out
#SBATCH --error='$sample'-subsample-pbs.%j.err

echo $HOSTNAME
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD/DATA-SAMPLES

sample='$sample'
gunzip '$sample'.extendedFrags.fastq.gz

# seqtk sample -s100 TARA_201.extendedFrags.fastq 10000 > TARA_201-subsample.fastq
seqtk sample -s100 '$sample'.extendedFrags.fastq 10000 > '$sample'-subsample.fastq

''' > $WD/DATA-SAMPLES/$sample'-subsample-pbs.sh'
done
