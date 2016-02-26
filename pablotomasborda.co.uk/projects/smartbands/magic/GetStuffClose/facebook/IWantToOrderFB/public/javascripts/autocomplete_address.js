
var current_json;
         
$(document).ready( function() {

    $( "#address" ).autocomplete({
        source: function (request,response) {
                  var current_addr = $("#address").val().split(" ");
                  var url_to_query = "http://soa1.getstuffclose.com:9494/geolocation/addresses?addr=";
                  var i=0;
                  for (i=0;i<current_addr.length;i++) {
                    url_to_query = url_to_query + current_addr[i] + "%20";
                  }
                  url_to_query = url_to_query + url_to_query[current_addr.length];
                  $.ajax({
                    type: "Get",
                    dataType: "json",
                    url: url_to_query,
                    success: function (data){ 
                      current_json = data;
                      //var data_obj = jQuery.parseJSON(data);
                      var j=0;
                      var availableTags = [];
                      for (i=0;i<data.results.length;i++){          
                        availableTags.push(data.results[i].formatted_address);  
                      }
                      response(availableTags);

                    }
                  }); 
        },
       // select: function(event, ui){
        	//var i=0;
        	//while ((i<current_json.results.length)&&(current_json.results[i].formatted_address!=ui.item.value)){
        	//	i = i + 1;
        	//}
        	//alert("Formatted: " + current_json.results[i].formatted_address + "Lattitude: " + current_json.results[i].geometry.location.lat + " Long: " + current_json.results[i].geometry.location.lng);
        //}
        //,
        disabled: false,        
        delay: 300
    });
});