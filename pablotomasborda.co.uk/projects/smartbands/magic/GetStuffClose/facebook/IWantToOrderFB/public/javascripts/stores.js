

function setaddr(){
 window.globaldata.order.addr = $("#address").val();
 window.globaldata.order.ap = $("#app").val(); 
 //$("<div id=\"checkaddr\">").html("");
  
}

function validate_address(){
 
	 if (window.globaldata['lat'] == undefined){
		 window.globaldata['lat'] = "-34.569897";
		 window.globaldata['lng'] = "-58.433856";
	 }
     var dir = "http://soa1.getstuffclose.com:9494/possible_location?lat=" + window.globaldata['lat'] + "&lng=" + window.globaldata['lng'];
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
	    top: true
   	  });

    $("#address").autocomplete({
      target: $('#suggestions'), // the listview to receive results
      source: 'http://soa1.getstuffclose.com:9494/geolocation/mobile/addresses', // URL return JSON data
      link: '#', // link to be attached to each result
      minLength: 5 // minimum length of search string
    });
      
}



function submitorder(){
  
   var order_products = $("#results").find("input[value!=0][type='text']").each(function(k,v){alert(k + " " + v.name);});
  
  $("#results").find("input[value!=0][type='text']").each(function(k,v){
    
    alert(k + " " + v.name + " " + v.value);
    window.globaldata.order.push({ product: v.name, amount: v.value, store: window.globaldata.currentstore});
    
  });
  validate_address();
}





function loadstore(item){
  var tmp = "";
  var items = "";
  var index = parseInt(item.substr(5));
  var companyname = window.globaldata.search_results[index][5];
  window.globaldata['companyname'] = companyname;
  window.globaldata['currentstore'] = window.globaldata.search_results[index];
  var dir = "http://soa1.getstuffclose.com:9494/products/allbysuperproductandcompany/" + companyname.replace(" ","%20");
  
  $.ajax({
    url: dir,
    dataType: 'json',
    async: false,
    context: document.body
  }).done(function(data) {
    window.products = data;
    $("#filters").hide();
    

  


    $.each(data,function(k,v){
      items = "";
      $.each(v,function(k1,v1){
	items = items + "<div class=\"ui-grid-b\">"; 
          items = items + "<div class=\"ui-block-a\">" + 
	                    "<h5>" + 
		  	      "<label onclick=\"loadproduct(" + v1.product.id.toString() + ");\">" +
			         v1.product.name.toString() + 
			      "</label>" + 
			    "</h5>" + 
			  "</div>" + 
			  "<div class=\"ui-block-b\">" + 
			    "<h5>" + 
			      v1.product.price.toString() + 
			    "</h5>" + 
			  "</div>" + 
			  "<div class=\"ui-block-c\">" + 
			    "<div data-role=\"fieldcontain\">" + 
			      "<fieldset data-role=\"controlgroup\" data-mini=\"true\">" + 
			        "<label for=\"" + v1.product.name.toString().split(' ').join('') + "\">" + 
			          "Amount" + 
			        "</label>" + 
			        "<input id=\"" + v1.product.name.toString().split(' ').join('') + "\" placeholder=\"\" value=\"0\" type=\"number\"  min=\"0\" max=\"1000\" name =\"" + v1.product.name.toString().split(' ').join('') + "\"/>" + 
			      "</fieldset>" + 
			    "</div>" + 
			  "</div>" + 
			"</div>";
      });
 
      if (k.toString() == $("#search").val()){
        tmp = tmp + "<div data-role=\"collapsible\" data-collapsed=\"false\">" + 
	              "<h3> " +
		        k + 
		      "</h3>" +
		        items +
		    "</div>";
      } else {
        tmp = tmp + "<div data-role=\"collapsible\" data-collapsed=\"true\">" +  
		        "<h3>" + 
			  k + 
			"</h3>" +
			  items +
		      "</div>";
      }
      

    });
    


    
  });

    
    return tmp;
}



function storeselected(item){
  
  loadstore(item);
}

function productselected(item){
  alert(item);  
}



function render_collapsable_company(name){
  var tmp = "";
  var companyname = window.globaldata.search_results[parseInt(name.substr(5))][5];
  tmp =  "<div data-role=\"collapsible\" data-collapsed=\"true\">" + 
          "<h3>" +
            companyname  + 
          "</h3>" +
          "<div data-role=\"collapsible-set\" data-theme=\"\" data-content-theme=\"\">" +                          
            loadstore(name) +
          "</div>" + 
          "</div>";
  return tmp;
}








function search_product(){
	 if (window.globaldata['lat'] == undefined){
		 window.globaldata['lat'] = "-34.569897";
		 window.globaldata['lng'] = "-58.433856";
	 }
	 var dir="http://soa1.getstuffclose.com:9494/stores/one_per_company/has_superprod/sorted_by_distance/sorted_by_price?companyid=21&superprod=" + $("#search").val() + "&lat=" + window.globaldata["lat"].toString() + "&lng=" + window.globaldata["lng"].toString();
  $.ajax({
    url: dir,
    dataType: 'json',
    async: false,
    timeout: 25000,
    context: document.body
  }).done(function(data) {
    window.globaldata['search_results'] = data;   
    $("#results > div").html("");
    //$("#results > div").append("<div class=\"ui-grid-b\">");
    $.each(data,function(key,value){
   
      

      if (value[2].toString()=="showstore"){
       /* $("#results").append("<table>" + 
	                       "<tr id=\"store" + key.toString() + "\"><td>" + 
                                 "<img src=\"http://dev.getstuffclose.com/images/" + value[5].toString().split(' ').join('') + "/" + value[6].toString() + "\" width=\"70\" height=\"46\">" +
			         render_collapsable_company("store" + key.toString()) +
			       "</td></tr>" + 
			     "</table>");*/
       $("#results > div").append(render_collapsable_company("store" + key.toString()));
       
       
        // $("#results > div").append(render_collapsable_company("store" + key.toString()));
	
	
      } else {
        //alert("showprod");
	//$("#results").append("<tr id=\"product" + key.toString() + "\">" + "<td><img src=\"http://dev.getstuffclose.com/images/" + value[5].toString().split(' ').join('') + "/" + value[6].toString() + "\" width=\"70\" height=\"46\">" + "</td><td>" + render_collapsable_company(key.toString()) + "</td>" + "</tr>");
      }

      

    });
    //$("#results > div").append("</div>");
    
    $( "div[data-role=page]" ).page( "destroy" ).page(); 
     
      $("#filters").show(); 
      $("#but").show();
}); 
}