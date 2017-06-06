
function(input, output, session) {
  output$mapa = renderLeaflet({
    leaflet() %>%
      addTiles() %>% 
      addMarkers(lat = matches$lat, lng = matches$lng, popup = matches$name, 
                 icon = icons(matches$picture, iconWidth = 32, iconHeight = 32))
  })
}