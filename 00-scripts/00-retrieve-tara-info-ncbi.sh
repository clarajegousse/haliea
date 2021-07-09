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

 #-block Attributes -subset Attribute -if @attribute_name -equals "sample material label" -element Attribute \
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
	  xtract -pattern DocumentSummary -element Biosample,Title \
	  -block Summary -element Platform@instrument_model \
	  -block Run -element Run@acc,Run@total_spots,Run@total_bases \
	  -block Library_descriptor -element LIBRARY_STRATEGY
 done > runs.txt

cat runs.txt | grep 'WGS' | grep 'paired' | cut -f 1,3,4,5,6,7 | sed 's/Illumina HiSeq /Illumina-HiSeq-/i' | grep 'Illumina-HiSeq-2*' > wgs-runs.txt
sort wgs-runs.txt > sorted-wgs-runs.txt

# select biosamples from the surface seawater (above 10m deep) and
# with lower size fractions of 0.22um to target prokaryotes
cat biosamples.txt | awk '$8 < 10 && $13 == 0.22' > srf-biosamples.txt
sort srf-biosamples.txt | uniq > sorted-srf-biosamples.txt

join sorted-wgs-runs.txt sorted-srf-biosamples.txt | sed -e 's/ /\t/g' > run-biosamples-infos.txt

# select biosamples without missing data (99999) and at latitude above 20 degree north
cat run-biosamples-infos.txt | grep -v 99999 |  awk '$11 > 20' > selected-run-biosamples-infos.txt

# generate the list of sra accession numbers
cat selected-run-biosamples-infos.txt | cut -f 3 > sra-accessions.txt

# generate the corresponding samples.txt file
cat selected-run-biosamples-infos.txt | cut -f 3,9 | awk 'BEGIN{print "sample\tr1\tr2"}{print $2 "\t" $1"_1.fastq.gz\t" $1"_2.fastq.gz"}' > samples.txt
