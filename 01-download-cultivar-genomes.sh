##!/usr/bin/env bash

WD=/users/home/cat3/projects/haliea
cd $WD

# get the assembly accession numbers for the cultivated strains
cat data/cultivar-genomes-taxid.txt | while read -r taxid;
do
  esearch -db genome -query "txid"$taxid"[Organism:exp]" </dev/null |\
    efetch -format docsum |\
    xtract -pattern DocumentSummary \
      -element TaxId,Organism_Name,Assembly_Accession,Status;
  #esearch -db genome -query "txid"$taxid"[Organism:exp]"
done > data/cultivar-assemblies-acc.txt

# download the genomes
cat data/cultivar-assemblies-acc.txt | cut -f 3 | while read -r acc ; do
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
      zcat $fname > data/cultivar-genomes/$spname.fna
      rm -f $fname
    done
done

# clean up
rm -f *.fna.gz; rm -f index.html*
