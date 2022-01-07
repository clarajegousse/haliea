library(ggplot)
library(ggpubr)
library(cowplot)

library(tidyr)
library(dplyr)

theme_set(theme_bw())
theme_update(text = element_text(size=12),
             panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             strip.background = element_blank(),
             aspect.ratio = 1
)

biome.col <- c(Sunflower, Aqua, Bittersweet, Grass)
names(biome.col) <- c("Coastal", 'Polar', 'Trade wind', 'Westerly')

# ----- import data -----

df <- read.csv2("/Users/Clara/Projects/haliea/INFOS/ncounts.csv", sep = ",", dec = ".")
head(df)

# ------ Preliminary screening ----

is.na(df) # no NA in the dataframe

ggplot(df, aes(y = temperature)) +
  geom_boxplot(outlier.colour="black", outlier.shape=16,
               outlier.size=2, notch=FALSE)

ggplot(df, aes(x = temperature)) +
  geom_histogram(bins = 30)

ggplot(df, aes(y = salinity)) +
  geom_boxplot(outlier.colour="black", outlier.shape=16,
               outlier.size=2, notch=FALSE)
ggplot(df, aes(x = salinity)) +
  geom_histogram(bins = 30)


df %>%
  filter(species == "Halieaalexandrii") %>%
  group_by(longhurst_region) 


# -----


str(df)
select(df, station_name, species, counts)

df %>%
  count(genus, species) %>%
  arrange(species, desc(n))


p1 <- ggplot(df, aes(x = temperature, fill = biome)) +
  geom_density(alpha = 0.5, color = NA) +
  scale_fill_manual(values = biome.col) +
  theme(legend.position = "none")

p2 <- ggplot(df, aes(x = salinity, fill = biome)) +
  geom_density(alpha = 0.5, color = NA) +
  scale_fill_manual(values = biome.col) +
  theme(legend.position = "none")

p3 <- ggplot(df, aes(x = oxygen, fill = biome)) +
  geom_density(alpha = 0.5, color = NA) +
  scale_fill_manual(values = biome.col) +
  theme(legend.position = "none") + facet_wrap(~biome)

p4 <- ggplot(df, aes(x = nitrate, fill = biome)) +
  geom_density(alpha = 0.5, color = NA) +
  scale_fill_manual(values = biome.col) +
  theme(legend.position = "none") + facet_wrap(~biome)

ggplot(df, aes(x = chlorophyll, fill = biome)) +
  geom_density(alpha = 0.5, color = NA) +
  scale_fill_manual(values = biome.col) +
  theme(legend.position = "none") + facet_wrap(~biome)


plot_grid(p1, p2, p3, p4, labels = c('A', 'B', 'C', 'D'), label_size = 12)

ggplot(df, aes(x = biome, y = temperature)) + 
  geom_boxplot(aes(fill = biome)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


ggboxplot(df, x = "longhurst_region", y = "counts",
          title = "Halieaceae", ylab = "Normalised read counts", xlab = "Longhurst region",
          color = "longhurst_region") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


ggplot(df) + geom_histogram(mapping = aes(x = temperature), bins = 15)

ggplot(data = df) +
  geom_bar(mapping = aes(x = longhurst_region))

fit <- glm(counts ~ biome, data=df[df$species == "Halieaalexandrii",], family=poisson())
summary(fit)



plot(counts ~ biome, data=df[df$species == "Halieaalexandrii",])

p <- ggplot(df[df$species == "Halieaalexandrii",], aes(temperature, counts))
p + geom_point(aes(colour=factor(longhurst_region))) + 
  theme(legend.position = c(.8,.7))




ggplot(df[df$species == "Halieaalexandrii",],aes(y=counts,x=temperature))+geom_point()+geom_smooth(method="glm")



hist(fit$residuals, breaks = 100)

plot(counts ~ temperature, data=df[df$species == "Halieasalexigens",])
