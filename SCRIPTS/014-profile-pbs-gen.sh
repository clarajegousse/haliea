#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# activate environment
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD/DATA-SAMPLES

#iu-gen-configs samples.txt -o $WD/DATA-SAMPLES

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
if [ "$sample" == "sample" ]; then continue; fi
echo $sample
echo '''#!/bin/bash
#SBATCH --job-name='$sample'-profile
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output='$sample'-profile.%j.out
#SBATCH --error='$sample'-profile.%j.err

echo $HOSTNAME
source /users/home/cat3/.bashrc
conda activate anvio-master

WD=/users/home/cat3/projects/haliea
cd $WD

anvi-profile -c $WD/HALIEA-CONTIGS.db \
-i DATA-SAMPLES/'$sample'.bam \
--profile-SCVs \
--num-threads 12 \
-o PROFILES/'$sample'
''' > $WD/DATA-SAMPLES/$sample'-profile-pbs.sh'
done
