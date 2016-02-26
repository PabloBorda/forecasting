
function showpic(picurl){
  
     $("#picscr").html("<img src=\"" + picurl + "\" width=\"221px\" height=\"227px\"/>");
  
  
}

function up(price){
	if ((parseInt($("#amountnum").val())+1)<1000){
		$("#amountnum").val(parseInt($("#amountnum").val())+1);
		
		$("#pricelabel").html(parseFloat(price)*parseInt($("#amountnum").val()) + " $");
	}
	
}

function down(price){
	if ((parseInt($("#amountnum").val())-1)>0){
		$("#amountnum").val(parseInt($("#amountnum").val())-1);
		$("#pricelabel").html(parseFloat(price)*parseInt($("#amountnum").val()) + " $");
	}
}

function renderproduct(product){
  //      window.global.gal = true;
        
	var tmp = "<div id=\"productdialog\">";
	var currenturl = "";
	var companyname = "";
	var dir = "http://soa1.getstuffclose.com:9494/company/" + product.product.company_id;
	if (product.product.pictures.length > 0){
	  if (($('.ui-page-active').attr('id')!="loading") && (window.globaldata["input"]!="back")){
		$.mobile.changePage($("#loading"));
	  }
	  tmp = tmp + "<div id=\"gallery\" align=\"center\"><div id=\"picscr\"></div><table><tr>";
	  $.ajax({url: dir,
	        dataType: "json",
	        async: true,
	        timeout: 25000,
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

	
	}
	tmp = tmp + "<div id=\"description\" align=\"center\"><h3>" + product.product.description + "</h3></div>";
	tmp = tmp + "<div align=\"right\"><table><tr><td><label id=\"pricelabel\">" + product.product.price + " $</label></td><td><table style=\"width: 122px; height: 66px;\">" + 
                     "<tr>" + 
                       "<td> <input type=\"number\" value=\"1\" min=\"0\" max=\"1000\" name=\"num\" id=\"amountnum\"> </td>" + 
                     "<td>" +                                             
                    "</tr>" +
                   "</table></td>" + "<td><table>" +
                   "<tr>" +
                   "<td><img id=\"up\" style=\"width: 50px; height: 54px;\" src=\"images/up.png\" onclick=\"up(" + product.product.price + ");\"/></td>" +
                 "</tr>" +
                 "<tr>" +
                   "<td><img id=\"down\" style=\"width: 50px; height: 54px;\" src=\"images/down.png\" onclick=\"down(" + product.product.price + ");\"/></td>" +
                 "</tr>" +
             "</table></td></table>" + 
                   "</div>";
	tmp = tmp + "</div>" + "<a rel='close' data-role='button' href='#' onclick='backtoresults();'>Add to cart</a>";

    if (($('.ui-page-active').attr('id')!="page1") && (window.globaldata["input"]!="back")){
	  $.mobile.changePage($("#loading"));
	}

    $("<div id=\"showprod\">").simpledialog2({
	    mode: 'blank',
	    headerText: product.product.name,
	    headerClose: true,
	    blankContent : tmp,
	    dialogAllow: true,
	    showModal: false,
	    dialogForce: true,
	    zindex: 3,
	    top: true,
	    fullScreen: true,
        fullScreenForce: true,
        animate: false
	  });
	
    
    
    return tmp;	
}


function backtoresults(){
	window.globaldata["input"] = "back";
	$.mobile.changePage($("#page1"));
	   
	 
}


function renderproduct1(product){
  //      window.global.gal = true;

	
	var tmp = "";
	var currenturl = "";
	var companyname = "";
	var dir = "http://soa1.getstuffclose.com:9494/company/" + product.product.company_id;
	if (product.product.pictures.length > 0){
	  tmp = tmp + "<ul id=\"Gallery\">";
	  $.ajax({url: dir,
	        dataType: "json",
	        async: false,
	        timeout: 25000,
	        context: document.body
	}).done(function(data){
	  companyname = data.company.name;
	  
	});

	$.each(product.product.pictures,function(k,v){
		fullpicurl = window.globaldata.picture_repository + companyname.split(' ').join('') + "/products/" + product.product.id + v.picture.url;
		thumburl = window.globaldata.picture_repository + companyname.split(' ').join('') + "/products/" + product.product.id + "/thumbs" + v.picture.url;
		tmp = tmp + "<li><a href=\"" + fullpicurl  + "\"><img href=\"" + thumburl + "\" alt=\"Image " + product.product.id + "\"/></a></li>";
	});

	tmp = tmp + "</ul>";

	
	}
	tmp = tmp + "<div id=\"description\" align=\"center\">" + product.product.description + "</div>";
	console.log(tmp);
	
	
	$.mobile.changePage("product.html");	
	$("#productdescription").html("");
	$("#productdescription").append(tmp);
	
	

	
	
}


function loadproduct(productid){
  if (window.globaldata["input"]!="back"){
    $.mobile.changePage("load.html");
  }
  var dir = "http://soa1.getstuffclose.com:9494/product/" + productid.toString();
 
  $.ajax({
    url: dir,
    dataType: 'json',
    async: false,
    context: document.body
  }).done(function(product) {
	
	  renderproduct(product);
     
     
  }
   );

    
}
