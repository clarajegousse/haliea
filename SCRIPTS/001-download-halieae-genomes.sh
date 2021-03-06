#!/bin/bash
#SBATCH --job-name=download-haliea-gen
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

WD=/users/home/cat3/projects/haliea/HALIEA-GENOMES
mkdir -p $WD
cd $WD

esearch -db taxonomy -query "txid1706372[Subtree]" |\
 efetch -format xml |\
 xtract -pattern Taxon \
 	-element TaxId,ScientificName > taxids.txt

# get the assembly accession numbers for the list of taxid
cat taxids.txt | cut -f 1 | while read -r taxid;
do
  esearch -db genome -query "txid"$taxid"[Organism:exp]" </dev/null |\
    efetch -format docsum |\
    xtract -pattern DocumentSummary \
      -element TaxId,Organism_Name,Assembly_Accession,Status;
  #esearch -db genome -query "txid"$taxid"[Organism:exp]"
done > assemblies.txt

# download the genomes
cat assemblies.txt | grep "GCA\_" | grep -v "Bacteria" | sort | uniq | cut -f 3 | while read -r acc ; do
  echo $acc
  esearch -db assembly -query $acc </dev/null \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_GenBank \
    | while read -r url ;
      do
      #echo "$url/$fname"
      fname=$(echo $url | grep -o 'GCA_.*' | sed 's/$/_genomic.fna.gz/') ;
      #echo $fname
      wget "$url/$fname"
      spname=$(zcat $fname | grep ">" | head -1 | cut -f 2,3 -d " " | sed 's/\ /-/i')
      #echo $spname
      zcat $fname > $spname.fna
      rm -f $fname
    done
done

# clean up
rm -f *.fna.gz; rm -f index.html*
