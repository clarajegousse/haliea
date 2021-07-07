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
col <- as.data.frame(cbind(longhurst$ProvCode, rep(MediumGrey, 54)))
colnames(col) <- c("code", "value")

col[col$code == "BPLR",]$value <- Jeans
col[col$code == "APLR",]$value <- Jeans
col[col$code == "ARCT",]$value <- Aqua
col[col$code == "ANTA",]$value <- Aqua
col[col$code == "ALSK",]$value <- Aqua
col[col$code == "SARC",]$value <- Mint
col[col$code == "SANT",]$value <- Mint
col[col$code == "NADR",]$value <- Sunflower
col[col$code == "NECS",]$value <- Sunflower
col[col$code == "MEDI",]$value <- Orange

# draw map with Longhurst provinces
map + geom_sf(data = longhurst, aes(fill = ProvCode), size = .1, col = "white", alpha=.4) +
  scale_fill_manual(values = col$value) +
  ggtitle(paste("Longhurst Biogeochemical Provinces -", length(unique(longhurst$ProvCode)),"provinces"))+
  theme(legend.position="none")+
  geom_sf_text(data = longhurst %>% group_by(ProvCode) %>% summarize(n()), aes(label = ProvCode),
               colour = DarkGrey, check_overlap = TRUE)+
  coord_sf(expand = FALSE) +
  geom_point(aes(x = -154.94 , y = 71.92, colour = "red")) 

