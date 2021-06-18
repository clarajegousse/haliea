##!/usr/bin/env bash

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
      echo "$url/$fname"
      fname=$(echo $url | grep -o 'GCA_.*' | sed 's/$/_genomic.fna.gz/') ;
      echo $fname
      wget "$url/$fname"
      zcat $fname > data/cultivar-genomes/$acc.fna
    done
done

# clean up
rm -f *.fna.gz; rm -f index.html*
