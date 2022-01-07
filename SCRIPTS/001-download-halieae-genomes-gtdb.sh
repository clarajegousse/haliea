#!/bin/bash
#SBATCH --job-name=download-haliea-gen
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

# to insure work with python3
source /users/home/cat3/.bashrc

# conda create --name haliea
conda activate haliea


WD=/users/home/cat3/projects/haliea/HALIEA-GENOMES
mkdir -p $WD
cd $WD

# get the list of genomes
# that belongs to the Halieaceae family in the GTDB
# query "GTDB Taxonomy" CONTAINS "f__Halieaceae"
# https://gtdb.ecogenomic.org

LIST=/users/home/cat3/projects/haliea/INFOS/gtdb_halieaceae.tsv

# --- Download the genomes ----

cat $LIST | cut -f 1 | grep -v "organism_name" | while read -r acc ; do
  echo $acc
  esearch -db assembly -query $acc </dev/null \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_GenBank \
    | while read -r url ;
      do
	  # build the url
      # echo "$url/$fname"
      fname=$(echo $url | grep -o 'GCA_.*' | sed 's/$/_genomic.fna.gz/') ;

	  # download file from url
	  # echo $fname
      wget "$url/$fname"
    done
done

# --- dereplication ----

checkm -h
checkm data setRoot /users/work/cat3/db/gtdbk
dRep dereplicate $WD/DREP -g $WD/*.fna.gz -d


# /users/home/cat3/miniconda3/lib/python3.8/site-packages/statsmodels/tools/_testing.py:19: FutureWarning: pandas.util.testing is deprecated. Use the functions in the public API at pandas.testing instead.
#   import pandas.util.testing as tm
# ***************************************************
#     ..:: dRep dereplicate Step 1. Filter ::..
# ***************************************************
#
# Will filter the genome list
# 117 genomes were input to dRep
# Calculating genome info of genomes
