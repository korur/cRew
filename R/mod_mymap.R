#' mymap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_mymap_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyMobile::f7Row(leaflet::leafletOutput(ns("mapp")))
  )
}
    
#' mymap Server Function
#'
#' @noRd 
mod_mymap_server <- function(input, output, session, abcd, lat, long, zoomin, zoomout) {
  ns <- session$ns
  
  
  
  mapp <- reactive({
    
    if(lat()!=71.00389) {
      
    m <- abcd() %>% leaflet::leaflet()  %>% 
      leaflet::addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>% 
      leaflet::addProviderTiles(leaflet::providers$Stamen.TonerHybrid) %>% 
      leaflet::addMarkers(long(), lat = lat(),  popup =   paste("<h3>","<b>", "You are here", "</b>", "</h3>")) %>% 
      leaflet::addCircleMarkers(lng=abcd()$long, lat=abcd()$lat, color = ifelse(abcd()$fever == 1 | abcd()$cough == 1 | abcd()$breath == 1, "red", "green")) %>%
      leaflet::setView(lng = long(), lat = lat(), zoom = 6 + zoomin() - zoomout()) 
    m
  } else {
    
    
      m <- abcd() %>% leaflet::leaflet()  %>% 
        leaflet::addTiles(
          urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>% 
        leaflet::addProviderTiles(leaflet::providers$Stamen.TonerHybrid) %>% 
        leaflet::addMarkers(long(), lat = lat(),  popup =   paste("<h3>","<b>", "Since we could not determine your location you are automatically redirected here", "</b>", "</h3>")) %>% 
        leaflet::addCircleMarkers(lng=abcd()$long, lat=abcd()$lat, color = ifelse(abcd()$fever == 1 | abcd()$cough == 1 | abcd()$breath == 1, "red", "green")) %>%
        leaflet::setView(lng = long(), lat = lat(), zoom = 2 + zoomin() - zoomout()) 
      m
      }
    }) 
    
  
  output$mapp <- leaflet::renderLeaflet({
    mapp()
  })
}
    
## To be copied in the UI
# mod_mymap_ui("mymap_ui_1")
    
## To be copied in the server
# callModule(mod_mymap_server, "mymap_ui_1")
 
