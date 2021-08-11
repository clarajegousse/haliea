#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# go to working directory
WD=/users/home/cat3/projects/haliea
cd $WD

#iu-gen-configs samples.txt -o $WD/DATA-SAMPLES

for sample in `awk '{print $1}' $WD/RAW-READS/samples.txt`
do
if [ "$sample" == "sample" ]; then continue; fi
echo $sample
echo '''#!/bin/bash
#SBATCH --job-name='$sample'-coverm
#SBATCH -p normal
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output='$sample'-coverm.%j.out
#SBATCH --error='$sample'-coverm.%j.err

echo $HOSTNAME
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD/DATA-SAMPLES
mkdir -p $WD/COVERAGES/

coverm genome -1 $WD/DATA-SAMPLES/'$sample'-QUALITY_PASSED_R1.fastq.gz \
-2 $WD/DATA-SAMPLES/'$sample'-QUALITY_PASSED_R2.fastq.gz \
--genome-fasta-directory $WD/HALIEA-GENOMES/ \
--genome-fasta-extension "fna" \
--dereplicate \
--methods "count" --min-covered-fraction 0 \
-o $WD/COVERAGES/'$sample'.tsv

''' > $WD'/DATA-SAMPLES/'$sample'-coverm-pbs.sh'
done
