#!/bin/bash
#SBATCH --job-name=retrieve-tara-info-ncbi
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/haliea
cd $WD/00-infos

# # search for all TARA shotgun bioprojects focusing on prokaryotes
# esearch -db BioProject -query TARA |\
#  efetch -format docsum |\
#  xtract -pattern DocumentSummary -element Project_Acc,Project_Name,Project_Title |\
#   grep Shotgun | grep prokaryotes
# # PRJEB9740 PRJEB1787

#echo -e "biosample_accession\ttitle\ttaxid\tstation\tmaterial_label\tlatitude\tlongitude\tdepth\ttemperature\tsalinity\tnitrate\toxygen\tsize_fraction" > biosamples.txt
esearch -db sra -query 'PRJEB9740[BioProject] OR PRJEB1787[BioProject]' |\
efetch -format docsum |\
xtract -pattern DocumentSummary -element Biosample | while read -r smp ;
 do
	  esearch -db biosample -query $smp  </dev/null |\
	  efetch -format docsum |\
	  xtract -pattern DocumentSummary \
	  -block SampleData -element BioSample@accession \
	  -block Description -element Title,Organism@taxonomy_id \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Sampling Station" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "sample material label" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Event Date/Time End" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Latitude End" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Longitude End" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Depth" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "temperature" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Salinity Sensor" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Nitrate Sensor" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Oxygen Sensor" -element Attribute \
	  -block Attributes -subset Attribute -if @attribute_name -equals "Size Fraction Lower Threshold" -element Attribute
done > biosamples.txt

#echo -e "biosample_accession\tplatform\trun_accession\ttotal-reads\ttotal_bases" > runs.txt
esearch -db sra -query 'PRJEB9740[BioProject] OR PRJEB1787[BioProject]' |\
efetch -format docsum |\
xtract -pattern DocumentSummary -element Biosample | while read -r smp ;
 do
	  #echo 'blabla'$smp
	  esearch -db sra -query $smp </dev/null |\
	  efetch -format docsum |\
	  xtract -pattern DocumentSummary -element Biosample -block Summary \
	  -element Platform@instrument_model \
	  -block Run -element Run@acc,Run@total_spots,Run@total_bases
 done > runs.txt

sort runs.txt > sorted-runs.txt
cat biosamples.txt | grep "_SRF_" | sort > sorted-srf-biosamples.txt
join sorted-runs.txt sorted-srf-biosamples.txt | sed -e 's/ /\t/g' | cut -f 5 > sra-accession.txt
