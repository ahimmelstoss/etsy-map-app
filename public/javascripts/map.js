function initialize() {
  var myLatlng = new google.maps.LatLng(40.698677, -73.985941)

  var mapOptions = {
    center: myLatlng,
    zoom: 8
  };
  var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  var marker = new google.maps.Marker({
    position: myLatlng,
    map: map,
    title: 'shop_name'
  });

  var contentString = '<div id="content">'+
'<div id="siteNotice">'+
'</div>'+
'<h1 id="firstHeading" class="firstHeading">'+shop_name+'</h1>'+
'<div id="bodyContent">'+
'<p>'+purchase_date+'</p>'+
'a href="https://www.etsy.com/shop/'+shop_name+'">'+shop_name+'</a>'
'</div>'+
'</div>';

  var infowindow = new google.maps.InfoWindow({
      content: contentString
  });

  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map,marker);
  });
}
google.maps.event.addDomListener(window, 'load', initialize);