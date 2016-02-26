// onSuccess Callback
//   This method accepts a `Position` object, which contains
//   the current GPS coordinates
//


// onSuccess Callback
//   This method accepts a `Position` object, which contains
//   the current GPS coordinates
//

   $(document).ready(function(){
	 document.addEventListener('deviceready', function() {

	   console.log("Initializing geolocation");

	   window.global['lat'] = null;
	   window.global['lon'] = null;
	   window.global['lng'] = null;
	   navigator.geolocation.getCurrentPosition(onSuccess, onError);

	   // updates location position every 3 minutes
       navigator.geolocation.watchPosition(onSuccess, onError, { frequency: 180000 });

      }, true);
   });


function distance_meters(p1,p2){
  meters = distance_kilometer(p1,p2)/1000; 
  console.log("Distance between p1 and p2 is: " + meters.toString());
  return meters;

}



function distance_kilometers(p1,p2){
var R = 6371; // km
var dLat = (p2.lat-p1.lat);
var dLon = (p2.lon-p1.lon);
var lat1 = p1.lat;
var lat2 = p2.lat;

var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
var d = R * c;

console.log("Distance between p1 and p2 is: " + d.toString());
return d;

}



function onSuccess(position) {
	alert("hola");
    alert('Latitude: '        + position.coords.latitude          + '\n' +
          'Longitude: '         + position.coords.longitude         + '\n' +
          'Altitude: '          + position.coords.altitude          + '\n' +
          'Accuracy: '          + position.coords.accuracy          + '\n' +
          'Altitude Accuracy: ' + position.coords.altitudeAccuracy  + '\n' +
          'Heading: '           + position.coords.heading           + '\n' +
          'Speed: '             + position.coords.speed             + '\n' +
          'Timestamp: '         + new Date(position.timestamp)      + '\n');
    
    
    if (((window.global['lat']==null) && (window.global['lon']==null)) || (distance_kilometers({lat: window.global['lat'],lon: window.global['lon']},{lat: position.coords.latitude,lon: position.coords.longitude}) >= 0.1)){
    
      window.global['lat'] = position.coords.latitude;
      window.global['lon'] = position.coords.longitude;
      window.global['alt'] = position.coords.altitude;
      window.global['lng'] = position.coords.longitude;
      console.log("Position: (" +  window.global['lat'] + "," + window.global['lat'] + "), Current Page: " + $('.ui-page-active').attr('id'));
      if (($('.ui-page-active').attr('id') == "page1") || ($('.ui-page-active').attr('id') == "loading")){
        // If user logged in to facebook, refresh view
        search_product();
        navigator.notification.vibrate(500); // Alerts user on new products by new location
        
      }
    }
   

};

// onError Callback receives a PositionError object
//
function onError(error) {
    alert('code: '    + error.code    + '\n' +
          'message: ' + error.message + '\n');
}


