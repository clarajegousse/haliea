#!/bin/bash
#SBATCH --job-name=gen-col
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

for split_name in `sqlite3 HALIEA-CONTIGS.db 'select split from splits_basic_info;'`
do
    # in this loop $split_name goes through names like this: HIMB058_Contig_0001_split_00001,
    # HIMB058_Contig_0001_split_00002, HIMB058_Contig_0001_split_00003, HIMB058_Contig_0001_split_00003...; so we can extract
    # the genome name it belongs to:
    MAG=`echo $split_name | awk 'BEGIN{FS="_"}{print $1}'`

    # print it out with a TAB character
    echo -e "$split_name\t$MAG"
done > HALIEA-GENOME-COLLECTION.txt

anvi-import-collection HALIEA-GENOME-COLLECTION.txt \
                       -c HALIEA-CONTIGS.db \
                       -p HALIEA-MERGED/PROFILE.db \
                       -C Genomes

anvi-summarize -c HALIEA-CONTIGS.db \
              -p HALIEA-MERGED/PROFILE.db \
              -C Genomes \
              --init-gene-coverages \
              -o HALIEA-SUMMARY

anvi-interactive -p HALIEA-MERGED/PROFILE.db \
-c HALIEA-CONTIGS.db \
-C Genomes \
--server-only -P 8080


anvi-export-splits-and-coverages -p HALIEA-MERGED/PROFILE.db \
                                 -c HALIEA-CONTIGS.db -o coverage
