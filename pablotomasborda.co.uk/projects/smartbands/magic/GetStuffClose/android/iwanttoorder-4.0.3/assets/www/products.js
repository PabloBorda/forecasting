
/*
function loadpicture_backgallery(galdiv){
  if (window.globa.gal) {
    showpic()
   var galwidth = gallerydiv.width;
   var galheight = gallerydiv.height;
   
  }
  
  
  
}

*/

function showpic(picurl){
  
     $("#picscr").html("<img src=\"" + picurl + "\" width=\"221px\" height=\"227px\"/>");
  
  
}



function renderproduct(product){
  //      window.global.gal = true;
        
	var tmp = "<div id=\"gallery\" align=\"center\"><div id=\"picscr\"></div><table><tr>";
	var currenturl = "";
	var companyname = "";
	var dir = "http://soa1.getstuffclose.com:9494/company/" + product.product.company_id;
	$.ajax({url: dir,
	        dataType: "json",
	        async: false,
	        context: document.body
	}).done(function(data){
	  companyname = data.company.name;
	  
	});
	$.each(product.product.pictures,function(k,v){
		fullpicurl = window.globaldata.picture_repository + companyname.split(' ').join('') + "/products/" + product.product.id + v.picture.url;
		thumburl = window.globaldata.picture_repository + companyname.split(' ').join('') + "/products/" + product.product.id + "/thumbs" + v.picture.url;
		tmp = tmp + "<td><a href=\"#\" onclick=\"showpic('" + fullpicurl  + "');\"><img src=\"" + thumburl + "\" alt=\"Image " + product.product.id + "\" width=\"80\" height=\"80\"/></a></td>";
	});

	tmp = tmp + "</tr></table></div>";
	tmp = tmp + "<div id=\"description\" align=\"center\">" + product.product.description + "</div>";
	tmp = tmp + "<div id=\"controls\" align=\"right\">" + 
			      "<fieldset data-role=\"controlgroup\" data-mini=\"true\">" + 
			        "<label for=\"" + product.product.name.toString().split(' ').join('') + "\">" + 
			          "Amount" + 
			        "</label>" + 
			        "<input id=\"" + product.product.name.toString().split(' ').join('') + "\" placeholder=\"\" value=\"0\" type=\"number\" min=\"0\" max=\"1000\" name =\"" + product.product.name.toString().split(' ').join('') + "\"/>" + 
			      "</fieldset>" +
	            "</div>";


    return tmp;	
}



function loadproduct(productid){


  var dir = "http://soa1.getstuffclose.com:9494/product/" + productid.toString();
  var tmp = "";
  $.ajax({
    url: dir,
    dataType: 'json',
    context: document.body
  }).done(function(product) {
     tmp = tmp + renderproduct(product) +  "<a rel='close' data-role='button' href='#'>Close</a>";
     
     $("<div id=\"dialog\">").simpledialog2({
   	    mode: 'blank',
   	    headerText: product.product.name,
   	    headerClose: true,
   	    blankContent : tmp,
   	    dialogAllow: true,
	    showModal: false,
   	    dialogForce: true,            
	    zindex: 3,
	    top: true
   	  });
    $("#gallery a").first().trigger("click");
    $("#controls input").change(function (el){
      
      $("#results input[name*=" + el.attr("name") + "]").val(el.val());
	
    });
     
     
     
  }
   );


  return tmp;
  
 
  
}
