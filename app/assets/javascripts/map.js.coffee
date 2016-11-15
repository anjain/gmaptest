# Variables
features = undefined
icon = undefined
map = undefined
map_center = undefined
map_type_id = undefined
#maxZoomLevel = undefined
minZoomLevel = undefined

# Events
$(document).ready ->
  initDefaults()
  initMap()
  return

$(document).on 'change', '#zoom', ->
  if @checked
    map.setOptions
      draggable: true
      zoomControl: true
      scrollwheel: true
      disableDoubleClickZoom: false
  else
    map.setOptions
      draggable: false
      zoomControl: false
      scrollwheel: false
      disableDoubleClickZoom: true
  return

# Functions
initDefaults = ->
  minZoomLevel = 3
  icon = '/images/marker.png'
  map_center = new (google.maps.LatLng)(41.926979, 12.517385)
  map_type_id = 'roadmap'
  features = [
    {
      position: new (google.maps.LatLng)(26.91539, 75.22820)
      text: '1st position'
    }
    {
      position: new (google.maps.LatLng)(20.91539, 75.22820)
      text: '2nd position'
    }
    {
      position: new (google.maps.LatLng)(17.91747, 80.22912)
      text: '3rd position'
    }
    {
      position: new (google.maps.LatLng)(37.682084, -97.305173)
      text: '4th position'
    }
    {
      position: new (google.maps.LatLng)(39.198168, -116.643085)
      text: '5th position'
    }
    {
      position: new (google.maps.LatLng)(13.768462, 100.653619)
      text: '6th position'
    }
  ]
  return

initMap = ->
  map = new (google.maps.Map)(document.getElementById('map'),
    zoom: 1
    minZoom: minZoomLevel
    center: map_center
    mapTypeId: map_type_id)

  lastValid = map.getCenter()
  google.maps.event.addListener map, 'center_changed', ->
    if map.getBounds().getNorthEast().lng() > map.getBounds().getSouthWest().lng()
      lastValid = map.getCenter()
    else
      map.panTo lastValid
    return

  i = 0
  feature = undefined
  while feature = features[i]
    addMarker feature
    i++
  return

addMarker = (feature) ->
  infowindow = undefined
  marker = undefined

  marker = new (google.maps.Marker)(
    position: feature.position
    icon: icon
    map: map)
  infowindow = new (google.maps.InfoWindow)(content: feature.text)

  marker.addListener 'click', ->
    infowindow.open map, marker
    return
  return