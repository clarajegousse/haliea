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

for url in `cat ../ftp-links-for-raw-data-files.txt`
do
	echo $url
    wget ftp://$url
done

#
# esearch -db sra -query ERR2762177 | efetch --format docsum
# esearch -db sra -query ERR2762177 \
# | esummary \
# | xtract -pattern DocumentSummary -element FtpPath_GenBank \
# | while read -r url ;
#
# prefetch ERR2762177

# scp -i ~/.ssh/id_rsa_ihpc /Users/Clara/Desktop/data/ERR2762181_1.fastq.gz cat3@garpur.ihpc.hi.is:/users/work/cat3/projects/haliea/data/metagenomes/
