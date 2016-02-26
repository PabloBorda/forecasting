
var store_count = -1;





function delete_store(store_num){
  window.global_data.Stores.splice(store_num,1);
  $("#stores-list tr").eq(store_num).remove();
}


function update_stores_table(){
  
  var i=window.global_data.Stores.length-1;  
  $("#stores-list").append("<tr><td>" + window.global_data.Stores[i]["street"] + "</td><td><a href=\"#\"><img src=\"/images/delete_icon.gif\" onClick=\"delete_store("+ i + ");\"></a></td></tr>");  	
}

function add_store(street){
	var lat = 0;
	var lon = 0;
	
	var i=0;
    while ((i<current_json.results.length)&&(current_json.results[i].formatted_address!=street)){
      i = i + 1;
    }
    if (current_json.results[i].formatted_address==street){
	lat = current_json.results[i].geometry.location.lat;
	lon = current_json.results[i].geometry.location.lng;
	
	store_count = store_count + 1;
	myaddr = {};
	myaddr["street"] = street;
	myaddr["lat"] = lat;
	myaddr["lon"] = lon;
	if (window.global_data.Stores == null){
	  window.global_data.Stores = [];
	}
	window.global_data.Stores.push(myaddr);
    }
	
}



$(document).ready(function (){
  $("#add-to-bottom").click(function (){
    add_store($("#addr").val());
    $("#addr").attr("value","");
    update_stores_table();
  });
  
  
  
});
