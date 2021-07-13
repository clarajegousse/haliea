library(rgeos)
library(sf) # World map
library(rnaturalearth)
library(ggplot2)
library(devtools)
library(dplyr)

# import colours
source_url('https://raw.githubusercontent.com/clarajegousse/colors/master/colors.R')

# retrieve world data
world_map <- rnaturalearth::ne_countries(scale = 'small', returnclass = c("sf"))

# Base map
map <- ggplot() +
  geom_sf(data = world_map, size = .2, fill = 'white', col = 'white') +
  theme(panel.grid.major = element_line(color = lightgrey, linetype = "dashed", size = 0.5))
map

# import longhurst provinces
longhurst <- sf::read_sf("/Users/Clara/Projects/haliea/00-infos/longhurst-world-v4-2010.shx")
names(longhurst)
head(longhurst)

# simplify data
longhurst <- longhurst %>%
  sf::st_simplify(dTolerance = 0.01) %>%
  dplyr::group_by(ProvCode,ProvDescr) %>%
  dplyr::summarise()
#plot(longhurst)

# make colour settings
library(cmocean)
col <- as.data.frame(cbind(longhurst$ProvCode, rep(MediumGrey, 54)))
colnames(col) <- c("code", "value")
#col$value <- colorRampPalette(brewer.pal(8, "Dark2"))(54)
col$value <- colorRampPalette(flatuicolors)(54)

#col[col$code == "BPLR",]$value <- Jeans

# draw map with Longhurst provinces
map + geom_sf(data = longhurst, aes(fill = ProvCode), size = .1, col = "white", alpha=.4) +
  scale_fill_manual(values = col$value) +
  ggtitle(paste("Longhurst Biogeochemical Provinces -", length(unique(longhurst$ProvCode)),"provinces"))+
  theme(legend.position="none")+
  geom_sf_text(data = longhurst %>% group_by(ProvCode) %>% summarize(n()), aes(label = ProvCode),
               colour = DarkGrey, size = 3, check_overlap = TRUE)+
  coord_sf(expand = FALSE) + labs(x = 'longitude', y = 'latitude')

df <- read.csv("/Users/Clara/Projects/haliea/00-infos/selected-run-biosamples-infos.txt", 
               sep = "\t", dec = ".", header = FALSE)
df
head(df)

colnames(df) <- c("biosample_accession", "sequencing_platform", "run_accession", 
                  "total_reads", "total_counts", "library_strategy", "sample_alias",
                  "taxid", "station_name", "sampling_date", "latitude", "longitude", "depth", 
                  "temperature", "salinity", "nitrate", "oxygen", "lower_size_fraction")


map +  geom_sf(data = longhurst, aes(fill = ProvCode), size = .1, col = "white", alpha=.4) +
  #scale_fill_manual(values = col$value) +
  theme(legend.position="none") +
  ggtitle(paste("Longhurst Biogeochemical Provinces -", length(unique(longhurst$ProvCode)),"provinces")) +
  coord_sf(expand = FALSE) + #expand = FALSE,   clip = "on", xlim = c(0,60), ylim = c(-50,50)
  geom_point(aes(x = df$longitude, y = df$latitude), size = 1, color = MediumGrey, alpha = 0.5) +
  geom_text(aes(x = df$longitude, y = df$latitude, label = substr(df$station_name, 1, 8)), 
            color = DarkGrey, size = 2, hjust=0, vjust=1)

df$longhurst_region <- NA
df[df$station_name == 'TARA_030',]$region <- "MEDI"
df[df$station_name == 'TARA_031',]$region <- "MEDI"
df[df$station_name == 'TARA_032',]$region <- "REDS"
df[df$station_name == 'TARA_033',]$region <- "REDS"
df[df$station_name == 'TARA_067',]$region <- "MEDI"
df[df$station_name == 'TARA_155',]$region <- "NADR"


