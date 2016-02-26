function get_possible_location(){
	 var dir = "http://soa1.papitomarket.com:9494/possible_location?lat=" + window.global['lat'] + "&lng=" + window.global['lng'];
	 var a = "";
     $.ajax({
       url: dir,
       dataType: 'json',
       context: document.body,
       async: false
     }).done(function(locations){
       a = locations.results[0].formatted_address.toString();
    });
	return a;
	
}

function reset(){
    $.mobile.changePage($("#sell"));
    $("#name").val("i.e: Red Hat with green flowers");
    $("#category").val("i.e: Clothes");
    $("#price").val("0");
    $("#superproduct").val("i.e: Hat");
    $("#description").val("");
}

function bye(){
	
	navigator.app.exitApp();
}



function verify_data(){
	var validation_result = true;
	if (($("#name").val()=="i.e: Red Hat with green flowers") || $("#name").val().length<4){
		validation_result = false;
		alert("Name is required");		
	} else {
	
	  if (($("#category").val()=="i.e: Clothes") || $("#category").val().length<4){
		validation_result = false;
		alert("Category is required");
	  } else {	
	
	    if (($("#price").val()=="0") || ($("#price").val()=="")){
		  validation_result = false;
		  alert("Price is required");
	    } else {	
	
	      if (($("#superproduct").val()=="i.e: Hat") || $("#superproduct").val().length<4){
		    validation_result = false;		
		    alert("Search tag is required");
	      } else {	
	
	        if (($("#description").val()=="") || $("#description").val().length<10){
		      validation_result = false;		
		      alert("Give us a better description");
	        } else {
	        	if ($("#image > img").attr("src").indexOf("success.png")==-1){
	        		validation_result = false;
	        		alert("You seem not to be a human, try again");
	        	}
	        	
	        	
	        }
	      }
	    }
	  }
	}
	
	
	
	
	
	
	return validation_result;
}



function publish(){
	
	if (verify_data()){
	  console.log("MEOBJECT = " + JSON.stringify(window.global.meobject));
	
	  window.global["companyname"]=window.global.meobject.id;
	  window.global["companylogo"]=window.global.meobject.picture;
	  window.global["email"]=window.global.meobject.email;
	  window.global["password"]="";
	  window.global["webpage"]="http://www.facebook.com/" + window.global.meobject.id;
	
  	  var addr = get_possible_location();
	
	  window.global["address"]=addr;

	  console.log("The address is: " + addr);
	  console.log("Pictures: " + JSON.stringify(window.pics));

      var success = function(r){          	
          var progress_str = Math.round((parseFloat(r.progress) * 100)/parseFloat(r.total)).toString();
          if (progress_str.indexOf("100")==-1){
    	    $("#progressnum").html("<font size=\"90px\"><label>" + progress_str + " %</label></font>");
          } else {
        	  sendAppInvitation();	
          }
      }
      var failed = function(r){
        alert("ERROR: Product could not be published");
      }


      window["current_file"] = 0;
      window["sent"] = 0;
    
      var d = new Date();
      var month = d.getMonth();
      var day = d.getDate();
      if (d.getMonth()<10) {
        month = "0" + d.getMonth().toString();
      }
      if (d.getDate()<10){
        day = "0" + d.getDate().toString();	
      }
      window.global["time"] = d.getFullYear().toString() + month + day + d.getHours().toString() + d.getMinutes().toString() + d.getSeconds().toString();
      //$.mobile.changePage($("#progress"));
      for (window["current_file"]=0;window["current_file"]<window.piccount;window["current_file"]++){
    	  window.sent = window.sent + 1;
      	  $("#progressdetail").append("<label>Uploading pictures: " + "pic " + window["current_file"] + "</label><br/>");
          window.plugins.fileUploader.uploadByUri("http://soa1.papitomarket.com:9494/new_product_social",window.pics[window["current_file"]],window.global,"pic" + window["current_file"].toString(),"pic" + window["current_file"].toString() + ".jpg","image/jpeg",success,failed);        
      }
    
      facebookWallPost();
      
	}
	
}