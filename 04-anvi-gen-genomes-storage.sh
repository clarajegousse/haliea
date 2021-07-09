#!/bin/bash
#SBATCH --job-name=gen-genomes-storage
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

echo -e "name\tcontigs_db_path" > external-genomes.txt
CONTIGSDB="01-halieaceae-dbs/*.db"

for cdb in $CONTIGSDB
do
  if [ "$cdb" == "01-halieaceae-dbs/HALIEA-CONTIGS.db" ]; then continue; fi
  spname=$(echo $cdb | cut -f 2 -d "/" | cut -f 1 -d "." | sed 's/-/_/')
  echo -e """$spname\t$WD$cdb""" >> $WD/external-genomes.txt
done

#cat external-genomes.txt

# # internal genomes (metabat bins)
echo -e """name\tbin_id\tcollection_id\tprofile_db_path\tcontigs_db_path
HIS200\tMETABAT__200\tmetabat2\t/users/work/cat3/projects/mime/results/coassembly/coassembly_wgs_surface/merge/PROFILE.db\t/users/work/cat3/projects/mime/results/coassembly/coassembly_wgs_surface/contigs.db
HIS96\tMETABAT__96\tmetabat2\t/users/work/cat3/projects/mime/results/coassembly/coassembly_wgs_surface/merge/PROFILE.db\t/users/work/cat3/projects/mime/results/coassembly/coassembly_wgs_surface/contigs.db""" > $WD/internal-genomes.txt

anvi-gen-genomes-storage -e $WD/external-genomes.txt \
  #-i data/internal-genomes.txt \
  -o HALIEA-GENOMES.db \
  --gene-caller 'prodigal'
