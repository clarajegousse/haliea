library(DESeq2)
library(ggplot2)
library(devtools)
library(dplyr)
library(stringr)

# https://hbctraining.github.io/DGE_workshop/lessons/02_DGE_count_normalization.html

# ----- PRELIMINARY SETTINGS -----

# set the directory to save img
img.path = "/Users/Clara/Projects/haliea/FIG/"

# import colours
source_url('https://raw.githubusercontent.com/clarajegousse/colors/master/colors.R')

# ----- DATA IMPORT -----

# ----- Count data -----

files.list <- list.files("/Users/Clara/Projects/haliea/MAPPING", pattern = "TARA*", full.names = TRUE)

i = 1
for(f in files.list){
  smp <- sub('\\.tsv$', '', basename(f)) 
  d <- as.data.frame(read.csv(f, sep = "\t", col.names = c("genomes", "read.count")))
  d <- d[!d$genomes == "*", ]
  
  d$sp <- str_split_fixed(d$genomes, "_", 2)[,1]
  #d <- d[,c("sp", "sample", "read.count")]
  d <- aggregate(x = d$read.count,               
                 by = list(d$sp),             
                 FUN = sum)  
  
  colnames(d) <- c('species', smp)
  #print(dim(d))
  if(i == 1){
    counts.df <- d
    i = 2
  }else{
    counts.df <- merge(counts.df, d, by = 'species')
  }
}

counts.df

# set the rownames
rownames(counts.df) <- counts.df$species

# remove the column used as rownames
counts.df <- counts.df[,2:63]

cts <- as.matrix(counts.df)
cts

# ----- metadata
mtdt.df <- read.csv2("/Users/Clara/Projects/haliea/INFOS/metadata.csv", sep = ",", dec = ".")
mtdt <- mtdt.df[mtdt.df$station_name %in% colnames(cts), ]

mtdt$station_name <- as.factor(mtdt$station_name)
mtdt$nb_runs <- as.factor(mtdt$nb_runs)
mtdt$longhurst_region <- as.factor(mtdt$longhurst_region)

head(mtdt)

# ---- NORMALISATION WITH DESEQ -----

dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = mtdt,
                              design= ~ longhurst_region)
counts(dds)

dds <- estimateSizeFactors(dds)
sizeFactors(dds)
normalized_counts <- counts(dds, normalized=TRUE)

#View(normalized_counts)
#View(counts(dds))

# normalised count
ncts <- reshape::melt(normalized_counts)
colnames(ncts) <- c("species", "station_name", "counts")

# ---- merge count and metadata into a complete dataframe

df <- merge(mtdt, ncts, by = "station_name")

# manual clean up // extra info

df$genus <- NA
df[grepl("Halioglobus", df$species), ]$genus <- "Halioglobus"
df[grepl("Haliea", df$species), ]$genus <- "Haliea"
df[grepl("Kineobactrum", df$species), ]$genus <- "Kineobactrum"
df[grepl("Luminiphilus", df$species), ]$genus <- "Luminiphilu"
df[grepl("Congregibacter", df$species), ]$genus <- "Congregibacter"
df[grepl("Chromatocurvus", df$species), ]$genus <- "Chromatocurvus"
df[grepl("Parahaliea", df$species), ]$genus <- "Parahaliea"

unique(df$species)
df$scientific.name <- NA
df[df$species == "Chromatocurvushalotolerans",]$scientific.name <- "Chromatocurvus halotolerans"
df[df$species == "Congregibacterlitoralis",]$scientific.name <- "Congregibacter litoralis"
df[df$species == "Halieaalexandrii",]$scientific.name <- "Haliea alexandrii"
df[df$species == "Haliearubra",]$scientific.name <- "Haliea rubra"
df[df$species == "Halieasalexigens",]$scientific.name <- "Haliea salexigens"
df[df$species == "Halioglobusjaponicus",]$scientific.name <- "Halioglobus japonicus"
df[df$species == "Halioglobuslutimaris",]$scientific.name <- "Halioglobus lutimaris"
df[df$species == "Halioglobusmaricola",]$scientific.name <- "Halioglobus maricola"
df[df$species == "Halioglobussediminis",]$scientific.name <- "Halioglobus sediminis"
df[df$species == "Halioglobuspacificus",]$scientific.name <- "Halioglobus pacificus"
df[df$species == "Kineobactrumsalinum",]$scientific.name <- "Kineobactrum salinum"
df[df$species == "Kineobactrumsediminis",]$scientific.name <- "Kineobactrum sediminis"
df[df$species == "Luminiphilussyltensis",]$scientific.name <- "Luminiphilus syltensis"
df[df$species == "Parahalieaaestuarii",]$scientific.name <- "Parahaliea aestuarii"
df[df$species == "Parahalieamediterranea",]$scientific.name <- "Parahaliea mediterranea"

df
write.table(df, file = "/Users/Clara/Projects/haliea/INFOS/ncounts.csv", sep = ",",
            na = "NA", dec = ".")

# ----- Phyloseq -----

rownames(mtdt) <- mtdt$station_name
library(phyloseq)


taxmat <- cbind(rownames(normalized_counts),
                Domain = 'Bacteria',
                Phylum = 'Proteobacteria',
                Class = 'Gammaproteobacteria',
                Order = 'Pseudomonadales',
                Family = 'Halieaceae',
                Genus = NA,
                Species = NA)
rownames(taxmat) <- rownames(normalized_counts)
taxmat <- taxmat[,-1]

taxa_names(taxtab) <- rownames(normalized_counts)
haliea <- phyloseq(otu_table(normalized_counts, taxa_are_rows = T), 
         sample_data(mtdt),
         tax_table(taxmat))

tax_table(haliea)['Parahalieamediterranea', 'Genus'] <- 'Parahaliea'
tax_table(haliea)['Parahalieaaestuarii', 'Genus'] <- 'Parahaliea'
tax_table(haliea)['Congregibacterlitoralis', 'Genus'] <- 'Congregibacter'
tax_table(haliea)['Chromatocurvushalotolerans', 'Genus'] <- 'Chromatocurvus'
tax_table(haliea)['Halieaalexandrii', 'Genus'] <- 'Haliea'
tax_table(haliea)['Haliearubra', 'Genus'] <- 'Haliea'
tax_table(haliea)['Halieasalexigens', 'Genus'] <- 'Haliea'
tax_table(haliea)['Halioglobusjaponicus', 'Genus'] <- 'Halioglobus'
tax_table(haliea)['Halioglobuslutimaris', 'Genus'] <- 'Halioglobus'
tax_table(haliea)['Halioglobusmaricola', 'Genus'] <- 'Halioglobus'
tax_table(haliea)['Halioglobuspacificus', 'Genus'] <- 'Halioglobus'
tax_table(haliea)['Halioglobussediminis', 'Genus'] <- 'Halioglobus'
tax_table(haliea)['Kineobactrumsediminis', 'Genus'] <- 'Kineobactrum'
tax_table(haliea)['Kineobactrumsalinum', 'Genus'] <- 'Kineobactrum'
tax_table(haliea)['Luminiphilussyltensis', 'Genus'] <- 'Luminiphilus'

plot_bar(haliea, fill = "Genus") + 
  geom_bar(aes(color=Genus, fill=Genus), stat="identity", position="stack")

plot_heatmap(haliea, method = "NMDS", distance = "bray")

haliea.ord <- ordinate(haliea, "NMDS", "bray")

#"samples", "sites", "species", "taxa", "biplot", "split", "scree"
plot_ordination(haliea, haliea.ord, type="split", color="biome", label="Genus")


plot_ordination(haliea, healia.ord, type="taxa", color="biome")

plot_net(haliea, distance = "(A+B-2*J)/(A+B)", type = "taxa", 
         maxdist = 0.5, color="Genus", point_label="Genus") 
