library(leaflet)
library(jsonlite)
library(sf)
library(XML)
library(shiny)

vicRoadsAddy <- "https://services2.arcgis.com/18ajPSI0b3ppsmMt/arcgis/rest/services/Principal_Bicycle_Network/FeatureServer/0"
# vicRoadsAddy <- "https://services2.arcgis.com/18ajPSI0b3ppsmMt/arcgis/rest/services/Principal_Bicycle_Network/FeatureServer/0/query?where=STATUS%20%3D%20'Existing'"

# VicRoads colour by 'TYPE' filter by Status: Existing or Proposed
vicRoadsType <- c("Not Designated", "Off Road", "On Road")
vicRoadsPal <- colorFactor(c("#ffffb3", "#1b9e77", "#d95f02"), vicRoadsType)

vicRoadsTypeDF <- data.frame(vicRoadsType)

# City of Melbourne
# cityMelb <- "https://data.melbourne.vic.gov.au/resource/hmuz-nz6m.json"
cityMelb <- "https://data.melbourne.vic.gov.au/api/geospatial/24aw-nd3i?method=export&format=GeoJSON"

# cityMelbData <- fromJSON(cityMelb, simplifyVector = FALSE)
# cityMelbData1 <- fromJSON(cityMelb)
cityMelbData <- st_read(cityMelb)
# Need to remove proposed routes with grep

# City of Melbourne colour by 'type'
# cityMelbPal <- colorFactor(topo.colors(4), cityMelbData$type)
cityMelbPal <- colorFactor(c("#7570b3", "#e7298a", "#1b9e77", "#d95f02"), cityMelbData$type)

# Maribyrnong City Council
mariAddy <- "https://data.gov.au/geoserver/bicycle-network-maribyrnong-city-council/wfs?request=GetFeature&typeName=ckan_baf3b710_336b_45b7_9ba3_31100f1f5620&outputFormat=json"
mariData <- st_read(mariAddy, stringsAsFactors=F)

# Remove proposed routes, transform and remove NULL geometry
mariData <- mariData[mariData$status=="Existing",]
mariData <- st_transform(mariData,4326)
mariData <- mariData[sapply(mariData$geometry, function(x){length(x)!=0}),]
# mariData <- st_zm(mariData, drop = T, what = "ZM")

mariPal <- colorFactor(c("#1b9e77", "#d95f02"), mariData$type)


# Geelong
geelongAddy <- "https://data.gov.au/dataset/7af9cf59-a4ea-47b2-8652-5e5eeed19611/resource/4dab6cfd-d590-4cac-9370-f6eddb287b13/download/bikepaths.kml"
# geelongAddy <- "https://data.gov.au/dataset/7af9cf59-a4ea-47b2-8652-5e5eeed19611/resource/3dbfea74-b8c3-46af-9f39-51c746dc68a0/download/bikepath.zip"
geelongData <- st_read(geelongAddy, stringsAsFactors=F)
# geelongData <- st_read(geelongAddy, layer = "SHAPEFILE")

# Extract kml Description field data
# kmlDescriptionTable <- function(x) {
#     a <- readHTMLTable(x[1], as.data.frame = F)[[1]]
#     b <- as.data.frame(t(a[[2]][1:2]),stringsAsFactors=F)
#     names(b) <- a[[1]][1:2]
#     return(b)
# }

# Extract road type from kml 'description' column, but only if it hasn't already happend (different dirvers).
if ( ! "type" %in% names(geelongData) ) {

    kmlDescriptionType <- function(x) {
        a <- readHTMLTable(x[1], as.data.frame = F)[[1]]
        return(a[[2]][2])
    }

    geelongData$type <- sapply(geelongData$Description,kmlDescriptionType)
    geelongData <- geelongData[,-2]
    
}

geelongData <- geelongData[!grepl("P",geelongData$type),]
geelongData <- st_zm(geelongData, drop = T, what = "ZM")

geelongPal <- colorFactor(c("#1b9e77", "#d95f02","#e7298a"), domain=geelongData$type,
                          levels=c("OFRD","ONRD","TRNG"))

# Get Vic Land TR_Road data and filter for bike trails (Type=)

# Bicycle
# https://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wms?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&WIDTH=512&HEIGHT=512&LAYERS=VMTRANS_TR_ROAD_BIKE_PATH&STYLES=&FORMAT=image%2Fpng&SRS=EPSG%3A4283&BBOX=141%2C-39%2C150%2C-34
# Meta: https://services.land.vic.gov.au/catalogue/metadata?anzlicId=ANZVI0803002595&publicId=guest&extractionProviderId=1#tab2


# All Roads
# roadTR <- "https://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wms?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&WIDTH=512&HEIGHT=512&LAYERS=VMTRANS_TR_ROAD_BIKE_PATH&STYLES=&FORMAT=image%2Fpng&SRS=EPSG%3A4283&BBOX=141%2C-39%2C150%2C-34"
roadTRbase <- "https://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wms"

# 
# leaflet() %>%
#     addProviderTiles(providers$CartoDB.Positron, group = "OSM Lite") %>%
#     addWMSTiles(baseUrl=roadTRbase, layers='VMTRANS_TR_ROAD_BIKE_PATH',
#                 options=WMSTileOptions(format="image/png",transparent=TRUE)) %>%
#     addPolylines(data=geelongData,
#                  color = ~geelongPal(type), weight = 3, opacity=0.6) %>%
#     addLegend("bottomright", pal = geelongPal, values = ~type,
#               group="Geelong Bike Network", data=geelongData,
#               title = "Geelong Bike Network", opacity = 1)
#                            

# table(sapply(geelongData$geometry, function(x){length(x)}))
