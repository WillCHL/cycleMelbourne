library(shiny)
library(leaflet)

navbarPage("Melbourne Bicycle Paths", theme="styles.css",
       tabPanel("map",
            div(class="outer",
                
                # If not using custom CSS, set height of leafletOutput to a number instead of percent
                leafletOutput("map", width="100%", height="100%")
                
            )
       ),
       tabPanel("about",
                h2("About"),
                p("I'm relatively new to commuting on a bike and have recently moved house so I've been doing a lot of trip planning with several different web sites open to try and find the best and safest route. So with ", tags$a(href="https://www.bicyclenetwork.com.au/rides-and-events/ride2work/", "Ride2Work")," day fast approaching I thought I'd try and combine a few of those different data sources in one map. It's a little quick-and-dirty (which kinda hurts as a perfectionist) but it does the job."),
                p("I still have a few more things I'd like to implement on the app but I'm hoping it can help your ride already."),
                h2("Data Source"),
                p("I have done very little with the data except to filter out 'Proposed' bike routes and try and match up colours for the types of bike paths (where I can decipher the codes). All data is pulled directly from the data source so it is as up-to-date as possible."),
                p("If you know of any other good bike path data sources then email me at will.horelacy AT gmail.com and I'll try and add it to the list."),
                h4("OSM Cycle Map"),
                p(tags$a(href="https://www.opencyclemap.org/?zoom=10&lat=-37.86759&lon=144.95618&layers=B0000", "data") ,
                  tags$a(href="https://www.opencyclemap.org/docs/", "key")),
                h4("VicRoad Bicycle Network"),
                p(tags$a(href="https://vicroadsopendata-vicroadsmaps.opendata.arcgis.com/datasets/principal-bicycle-network", "data")),
                h4("City of Melbourne"),
                p(tags$a(href="https://data.melbourne.vic.gov.au/Transport-Movement/Bicycle-routes-including-informal-on-road-and-off-/24aw-nd3i", "data")),
                h4("Maribyrnong City Council"),
                p(tags$a(href="https://data.gov.au/dataset/bicycle-network-maribyrnong-city-council", "data")),
                h4("Greater Geelong Bike Paths"),
                p(tags$a(href="https://data.gov.au/dataset/7af9cf59-a4ea-47b2-8652-5e5eeed19611", "data"))
                
       )
)
