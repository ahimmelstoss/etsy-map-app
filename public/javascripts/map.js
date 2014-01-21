var map;
var geocoder;
function initialize() {
  geocoder = new google.maps.Geocoder();
  var myLatlng = new google.maps.LatLng(20.121587,13.952138)
  var mapOptions = {
    center: myLatlng,
    zoom: 2
  };
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
}

function codeOneAddress(datum) {
  geocoder.geocode( {'address': datum.location}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);

      var marker = new google.maps.Marker({
        map: map,
        animation: google.maps.Animation.DROP,
        position: results[0].geometry.location
      });
      var infowindow = new google.maps.InfoWindow();
      google.maps.event.addListener(marker, 'click', (function(marker, title, url) {
        return function() {
          infowindow.setContent('<a target="_blank" href="'+url+'">'+title+'</a>');
          infowindow.open(map, marker);
        }
      })(marker, datum.title, datum.url));

    } else {
      console.log("Geocode was not successful for the following reason: " + status + ". Geocoding failed for " + datum.location);
    }
  });
} 

function delayCoding(datum, delay_ms) {
  setTimeout(function() {
    codeOneAddress(datum);
  }, delay_ms);
}

function codeAddresses(data) {
  for (var i = 0; i < data.length; i++) {
    delayCoding(data[i], (i + 1) * 500);
  }
}

google.maps.event.addDomListener(window, 'load', initialize);