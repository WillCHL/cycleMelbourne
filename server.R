library(leaflet)
library(leaflet.esri)

function(input, output, session) {
    
    # Create the map
    output$map <- renderLeaflet({
        leaflet() %>%
            addProviderTiles(providers$Thunderforest.OpenCycleMap, group = "OSM Cycle Map",
                             options = providerTileOptions(apikey="2255133dae764e2ea27cb3a4a4c696e2")) %>%
            addProviderTiles(providers$CartoDB.Positron, group = "OSM Lite") %>%
            addTiles(group = "OSM") %>%
            addEsriFeatureLayer(url=vicRoadsAddy,
                                options=featureLayerOptions(where = "STATUS='Existing'",
                                                            style = JS("function(feature){
                    var props = feature.properties;
                                                                       if(props.TYPE === 'On Road'){
                                                                       return {color: '#d95f02'};
                                                                       } else if(props.TYPE === 'Off Road'){
                                                                       return {color: '#1b9e77'};
                                                                       } else {
                                                                       return {color: '#ffffb3'};
                                                                       }
                                                                       }")),
                                useServiceSymbology = F, weight = 3, fillOpacity=0, opacity=0.6,
                                group="VicRoads Bicycle Network") %>%
            addPolylines(data=cityMelbData, group="City of Melb Bicycle Routes",
                         weight = 3, opacity=0.6, color=~cityMelbPal(type)) %>%
            addPolylines(data=mariData, group="Maribyrnong Bike Network",
                         weight = 3, opacity=0.6, color=~mariPal(type)) %>%
            addPolylines(data=geelongData, group="Geelong Bike Network",
                         color = ~geelongPal(type), weight = 3, opacity=0.6) %>%
            addLayersControl(
                baseGroups = c("OSM", "OSM Lite", "OSM Cycle Map"),
                overlayGroups = c("VicRoads Bicycle Network", "City of Melb Bicycle Routes", 
                                  "Maribyrnong Bike Network", "Geelong Bike Network"),
                options = layersControlOptions(collapsed = FALSE)) %>%
            addLegend("bottomright", pal = cityMelbPal, values = ~type,
                      group="City of Melb Bicycle Routes", data=cityMelbData,
                      title = "City Melb Path Type", opacity = 1) %>%
            addLegend("bottomright", pal = vicRoadsPal, values = ~vicRoadsType,
                      group="VicRoads Bicycle Network", data=vicRoadsTypeDF,
                      title = "VicRoad Bicycle Network", opacity = 1) %>%
            addLegend("bottomright", pal = mariPal, values = ~type,
                      group="Maribyrnong Bike Network", data=mariData,
                      title = "Maribyrnong Bike Network", opacity = 1) %>%
            addLegend("bottomright", pal = geelongPal, values = ~type,
                      group="Geelong Bike Network", data=geelongData,
                      title = "Geelong Bike Network", opacity = 1) %>%
            setView(lng = 144.92, lat = -37.8, zoom = 9) %>% 
            hideGroup(c("VicRoads Bicycle Network", "City of Melb Bicycle Routes",
                        "Maribyrnong Bike Network", "Geelong Bike Network"))
            
    })
}
