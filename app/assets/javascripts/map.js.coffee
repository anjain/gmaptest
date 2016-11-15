# Variables
features = undefined
icon = undefined
map = undefined
map_center = undefined
map_type_id = undefined
#maxZoomLevel = undefined
minZoomLevel = undefined
all_markers = []

# Events
$(document).ready ->
  setMapSize()
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

# map resize on window screen resize
$(window).on 'resize', ->
  setMapSize()
  return

# Functions
# set map size on basis of screen sizes
setMapSize = ->
  map_width = $(window).width() - 20
  map_height = $(window).height() - 80
  $('#map_container').css('width', map_width)
  $('#map').css('width', map_width)
  $('#map').css('height', map_height)

# Variables initialization
initDefaults = ->
  minZoomLevel = 3
  icon = '/images/marker.png'
  map_center = new (google.maps.LatLng)(41.926979, 12.517385)
  map_type_id = 'roadmap'
  features = [
    {
      position: new (google.maps.LatLng)(26.91539, 76.22820)
      text: '1st position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(26.91539, 77.22820)
      text: '1st position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(26.91539, 78.22820)
      text: '1st position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(26.91539, 79.22820)
      text: '1st position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(27.91539, 77.22820)
      text: '1st position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(20.91539, 75.22820)
      text: '2nd position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(17.91747, 80.22912)
      text: '3rd position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(37.682084, -97.305173)
      text: '4th position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(39.198168, -116.643085)
      text: '5th position'
      user: '/images/user.png'
    }
    {
      position: new (google.maps.LatLng)(13.768462, 100.653619)
      text: '6th position'
      user: '/images/user.png'
    }
  ]
  return

# Map Initialization
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
    marker = createMarker(map, feature)
    all_markers.push marker
    i++
  setCluster(map, all_markers)
  return

# Set cluster for all markers
setCluster = (map, all_markers) ->
  markerClusterer = new MarkerClusterer(map, all_markers,
    maxZoom: 15
    gridSize: 40
    styles: [ {
      url: '/images/cluster_pin.png'
      height: 71
      width: 60
    } ])
  return

# Create markers
createMarker = (map, item) ->
  div = document.createElement('div')
  div.className = 'marker-prop'
  div.style.cursor = 'pointer'
  div.innerHTML = '<img src="' + item.user + '">'

  marker = new RichMarker(
    position: item.position
    map: map
    draggable: false
    flat: true
    anchor: RichMarkerPosition.BOTTOM
    content: div)

  infowindow = new google.maps.InfoWindow(content: item.text)
  marker.addListener 'click', ->
    infowindow.open map, marker
    return
  marker
  