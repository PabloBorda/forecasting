

function setaddr(){
 window.globaldata.order.addr = $("#address").val();
 window.globaldata.order.ap = $("#app").val(); 
 //$("<div id=\"checkaddr\">").html("");
  
}

function validate_address(){
 
     var dir = "http://soa1.getstuffclose.com:9494/possible_location?lat=" + window.globaldata['lat'] + "&lng=" + window.globaldata['lon'];
     var selectaddr = "";
     $.ajax({
       url: dir,
       dataType: 'json',
       context: document.body,
       async: false
     }).done(function(locations){
       selectaddr = "<select name=\"gpsok\">";
       $.each(locations.results, function(k,v){
	 selectaddr = selectaddr + "<option value=\"" + k.toString() + "\">" + v.formatted_address.toString() +  "</option>";
       });
       selectaddr = selectaddr + "</select>";
       
    });

     var checkaddr_content = "<label>The GPS is not always accurate, </label></br>" +
                              "<label>Select one of the following addresses: </label> </br>" +
                               selectaddr + "</br> <label>Or even better, input your address" + 
			       " in the following autocomplete field </label></br>" + 
			       "<input type=\"text\" id=\"address\" name=\"address\"/>" + 
			       "<ul id=\"suggestions\" data-role=\"listview\" data-inset=\"true\" class=\"ui-listview ui-listview-inset ui-corner-all ui-shadow\"></ul>" + 
			       "</br><div align=\"right\"\><label>If appartment</label>" + 
			       "<input type=\"text\" id=\"app\" name=\"app\" style=\"width:20px\"/></div></br>" + 
			       "<a rel=\"close\" onclick=\"setaddr();\" data-role=\"button\" href=\"#\">Verified</a>";
     
      $("<div id=\"checkaddr\">").simpledialog2({
   	    mode: 'blank',
   	    headerText: "Verify Location",
   	    headerClose: true,
   	    blankContent : checkaddr_content,
   	    dialogAllow: true,
	    showModal: false,
   	    dialogForce: true,
	    top: true,
	    animate: false
   	  });

    $("#address").autocomplete({
      target: $('#suggestions'), // the listview to receive results
      source: 'http://soa1.getstuffclose.com:9494/geolocation/mobile/addresses', // URL return JSON data
      link: '#', // link to be attached to each result
      minLength: 5 // minimum length of search string
    });
    
    window.globaldata['input'] = "null";
      
}



function submitorder(){
  
   var order_products = $("#results").find("input[value!=0][type='text']").each(function(k,v){alert(k + " " + v.name);});
  
  $("#results").find("input[value!=0][type='text']").each(function(k,v){
    
    alert(k + " " + v.name + " " + v.value);
    window.globaldata.order.push({ product: v.name, amount: v.value, store: window.globaldata.currentstore});
    
  });
  validate_address();
}

function loadstore(store,products){
  var tmp = "";
  var other_outer="";
  var other_inner="";
  var items = "";
  var companyname = store[5];
  
  
  $("#filters").hide();
    
  var first_non_selected = false;
  $.each(products,function(k,v){
    items = "<table><tr><td>View</td><td align=\"center\">Product</td><td align=\"center\">Price</td><td align=\"center\">Amount</td></tr>";
    $.each(v,function(k1,v1){	  
  	  items = items + "<tr><td><img src=\"images/view.png\" width=\"35\" height=\"30\" onclick=\"loadproduct(" + v1.product.id.toString() + ");\"/></td><td align=\"center\"><label onclick=\"loadproduct(" + v1.product.id.toString() + ");\">" +
	          v1.product.name.toString() + 
		      "</label></td>" + "<td><h5>" + 
		      v1.product.price.toString() + 
			  "</h5></td><td>" + 
			  "<input id=\"" + v1.product.name.toString().split(' ').join('') + "\" placeholder=\"\" value=\"0\" type=\"number\"  min=\"0\" max=\"1000\" name =\"" + v1.product.name.toString().split(' ').join('') + "\"/></td></tr>";
      });
      items = items + "</table>";
      if (k.toString() == $("#search").val()){
        tmp = tmp + "<div data-role=\"collapsible\" data-collapsed=\"false\">" + 
	              "<h3> " +
		        k + 
		      "</h3>" +
		        items +
		    "</div>";
      } else {          
          other_inner = other_inner + "<div data-role=\"collapsible\" data-collapsed=\"true\">" +  
          "<h3>" + 
  	        k + 
  	      "</h3>" +
  	        items +
          "</div>";    	
      }
      
    });
  
  
	other_outer = other_outer + "<div data-role=\"collapsible\" data-collapsed=\"true\">" +
    "<h3>" + "Other Products" + "</h3>";
    other_outer = other_outer + other_inner;  
    other_outer = other_outer + "</div>";

    tmp = tmp + other_outer;

    return tmp;
}



function storeselected(item){
  
  loadstore(item);
}

function productselected(item){
  alert(item);  
}



function render_collapsable_company(store,products){
  var tmp = "";
  var companyname = store[5];
  var show_online = "<img src=\"file:///android_asset/www/images/online.png\" alt=\"online\"/>";
  var show_offline = "<img src=\"file:///android_asset/www/images/offline.png\" alt=\"offline\"/>";
  
  
  tmp =  "<div data-role=\"collapsible\" data-collapsed=\"true\">" + 
          "<h3>" + "<table style=\"width: 100%;\" border=\"0\"><tr><td>" + show_online +  "</td><td>" + "<img src=\"http://dev.getstuffclose.com/images/" + store[5].toString().split(' ').join('') + "/" + store[6].toString() + "\" width=\"70\" height=\"46\"" + "alt=\"" + companyname + "\"/></td><td>" + companyname + "</td>" + "<td align=\"center\" style=\"height: 100%;\"><h5><label>" + Math.round(store[7]*100).toString() + " mtr</h5></label></td></tr></table>" +             
          "</h3>" +
          "<div data-role=\"collapsible-set\" data-theme=\"\" data-content-theme=\"\">" +                          
            loadstore(store,products) +
          "</div>" + 
          "</div>";

  return tmp;
}








function search_product(){
  //var dir="http://soa1.getstuffclose.com:9494/stores/one_per_company/has_superprod/sorted_by_distance/sorted_by_price?companyid=21&superprod=" + $("#search").val() + "&lat=" + window.globaldata["lat"].toString() + "&lng=" + window.globaldata["lng"].toString();
  console.log("Search term: " + $("#search").val());
  console.log("Latitude :" + window.global["lat"].toString());  
  console.log("Longitude :" + window.global["lng"].toString());
  var dir="http://soa1.getstuffclose.com:9494/search?superprod=" + $("#search").val() + "&lat=" + window.global["lat"].toString() + "&lng=" + window.global["lng"].toString();
  if (window.globaldata["input"] != "back"){
    $.mobile.changePage("load.html");   
  }
  $.ajax({
    url: dir,
    dataType: 'json',
    async: true,  // true asynchronous web service consumption
    timeout: 25000,
    context: document.body
  }).done(function(data) {
    window.globaldata['search_results'] = data;   
    $("#results > div").html("");
    //$("#results > div").append("<div class=\"ui-grid-b\">");
    $.each(data,function(key,value){
   
      

      if (value.store[2].toString()=="showstore"){
    	  $("#results > div").append(render_collapsable_company(value['store'],value['products']));
       
	
      } else {
        //alert("showprod");
	//$("#results").append("<tr id=\"product" + key.toString() + "\">" + "<td><img src=\"http://dev.getstuffclose.com/images/" + value[5].toString().split(' ').join('') + "/" + value[6].toString() + "\" width=\"70\" height=\"46\">" + "</td><td>" + render_collapsable_company(key.toString()) + "</td>" + "</tr>");
      }

      

    });
    $( "div[data-role=page]" ).page( "destroy" ).page(); 
     
      $("#filters").show(); 
      $("#but").show();
      
     
  });
  $.mobile.changePage("index.html#page1");
  
}	