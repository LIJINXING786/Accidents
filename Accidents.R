
data = read.csv("accident-dataV1.csv")

library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()


ui <-  fluidPage(
  h1("2020 Accidents"),
  sidebarLayout(
    sidebarPanel( 
      sliderInput(inputId = "accident_severity",
                  label = "accident severity",
                  min = 1,
                  max = 3,
                  value = 2,
                  step=1
      ),
      sliderInput(inputId = "speed_limit",
                  label = "speed limit",
                  min = 20,
                  max = 70,
                  value = 30,
                  step=10
      ),
      
      sliderInput(inputId = "day_of_week",
                  label = "day of week",
                  min = 1,
                  max = 7,
                  value = 3,
                  step=1
      ),
      
      sliderInput(inputId = "weather_conditions",
                  label = "weather conditions",
                  min = 1,
                  max = 9,
                  value = 2,
                  step=1
      ),
    ),
    mainPanel( leafletOutput("mymap")
    )
  )
  
)

server <- function(input, output, session) {
  
  dt <- reactive({
    
    data[data$accident_severity == as.numeric(input$accident_severity) &
           data$day_of_week == as.numeric(input$day_of_week) &
           data$weather_conditions == as.numeric(input$weather_conditions) &
           data$speed_limit == as.numeric(input$speed_limit),
    ]
    
  })
  
  
  output$mymap <- renderLeaflet({
    dat <- dt()[,c(4,5)]
    leaflet() %>%setView(lng = -1.1893, lat = 52.35, zoom = 6) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addCircleMarkers(lng = dat$longitude, lat = dat$latitude, radius = 4) 
  })
}

shinyApp(ui, server)
