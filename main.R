# load required packages
library(mapview)
library(tidyverse)
library(sf)
library(readxl)
library(git2r)
library(taskscheduleR)

# read summit data
summits <- read_delim("swissNAMES3D_PKT.csv", delim = ";")

# filter data to keep summits only
unique(summits$OBJEKTART)
summits <- summits %>%
  filter(OBJEKTART %in% c("Gipfel", "Hauptgipfel", "Alpiner Gipfel", "Huegel", "Haupthuegel"))

write_excel_csv (summits, "summits.csv")

# read updaten summits file
summits <- read_excel("C:/Users/andd/OneDrive - ZHAW/summits.xlsx")

summits_sf <- st_as_sf(summits, 
                       coords = c("E", "N"),
                       crs = 2056)

summits_sf <- st_transform(summits_sf, crs = 4326)

Bestiegen_sf <- summits_sf %>%
  filter(Bestiegen == TRUE)

mapviewOptions(fgb = FALSE)

Karte <- 
  mapview(summits_sf, col.regions = "blue", color = "blue", alpha.regions = 0.22, cex = 2.5, layer.name = "Gipfel",
        map.types = c("OpenStreetMap", "Esri.WorldImagery"), label = "NAME")+
  mapview(Bestiegen_sf, col.regions = "red", color = "red", layer.name = "Gipfelpflicht", cex = 5, alpha.regions = 1,
          map.types = c("Esri.WorldImagery", "OpenStreetMap"), label = "NAME")

Karte

mapshot(Karte, url = "Karte.html")

#
