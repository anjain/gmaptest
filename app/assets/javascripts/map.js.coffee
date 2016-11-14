# Variables
map = undefined
map_center = undefined
map_type_id = undefined
minZoomLevel = undefined
maxZoomLevel = undefined
features = undefined
icon = undefined
zoom_allowedBounds = undefined

# Events
# Variables initialization
initDefaults = ->
  minZoomLevel = 2
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
  ]
  zoom_allowedBounds =
    '2': [
      70.33956792419954
      178.01171875
      83.86483689701898
      -88.033203125
    ]
    '3': [
      30.33956792419954
      178.01171875
      83.86483689701898
      -88.033203125
    ]
  return

# Map Initialization
initMap = ->
  map = new (google.maps.Map)(document.getElementById('map'),
    zoom: 2
    minZoom: minZoomLevel
    center: map_center
    mapTypeId: map_type_id)
  setBound map
  # set bounds for limiting infinite horizontal scrolling
  # Limit the zoom level
  google.maps.event.addListener map, 'zoom_changed', ->
    setBound map, map.getZoom()
    return
  # add markers to map
  i = 0
  feature = undefined
  while feature = features[i]
    addMarker feature
    i++
  return

# Set allowed bounds to map according to zoom
setBound = (map, zoom_level = 2) ->
  zoom_level_bounds = zoom_allowedBounds[zoom_level]
  southWest = new (google.maps.LatLng)(zoom_level_bounds[0], zoom_level_bounds[1])
  northEast = new (google.maps.LatLng)(zoom_level_bounds[2], zoom_level_bounds[3])
  allowedBounds = new (google.maps.LatLngBounds)(southWest, northEast)
  lastCenter = map.getCenter()
  google.maps.event.addListener map, 'dragstart', ->
    lastCenter = map.getCenter()
    return
  google.maps.event.addListener map, 'dragend', ->
    center = map.getCenter()
    if allowedBounds.contains(center)
      return
    map.setCenter lastCenter
    return
  return

# Add marker image
addMarker = (feature) ->
  marker = new (google.maps.Marker)(
    position: feature.position
    icon: icon
    map: map)
  infowindow = new (google.maps.InfoWindow)(content: feature.text)
  marker.addListener 'click', ->
    infowindow.open map, marker
    # map.setCenter(marker.getPosition());  // Uncomment this for center the map to marker
    return
  return

$(document).ready ->
  initDefaults()
  initMap()
  return

# Zoom disable event
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