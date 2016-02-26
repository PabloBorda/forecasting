function sendAppInvitation(){
	var sendTo = [];
	
	$("input[type='checkbox']").each(function(){		
		if (this.checked){
			sendTo.push(this.name);			
		}
	});
	
    
	FB.ui({method: 'apprequests',
	    message: window.global.meobject.name + ' invites you to Buy and Sell using PapitoMarket!',
	    to: sendTo
	},function(response){
		alert(JSON.stringify(requestSent));
	});
	
}





function invertSelection(){
	//alert("INVERT");
	
	$("input[checked='true']").each(function(){
		if (this.checked) {			
			this.checked = false;
		} else {			
			this.checked = true;
		}
				
	});
}


function invite(){
	$.mobile.changePage($("#invite"));	
	me();
}


function settings(){
	
	$.mobile.changePage($("#settings"));
}



function nextsell1(){
	$.mobile.changePage($("#sell1"));
	
}

function nextsell2(){
	$.mobile.changePage($("#sell2"));
	
}


function addpic(){
	
	if ($("#selectmenu1").val()=="camera"){
		capturePhoto();
	} else {
		getPhoto(pictureSource.PHOTOLIBRARY);
	}
}




function next(){
	
	var index = window.pages.indexOf($('.ui-page-active').attr('id')) + 1;
	
	if (index > window.pages.length){
		return $('.ui-page-active').attr('id');
	} else {
		return window.pages[index];
	}
}

function prev(){
	
	var index = window.pages.indexOf($('.ui-page-active').attr('id')) - 1;
	
	if (index < 0){
		return $('.ui-page-active').attr('id');
	} else {
		return window.pages[index];
	}
	
}


/*
function initialize_canvas(){
    var sizedWindowWidth = $(window).width() / 4;
    
    $("#canvas").width(sizedWindowWidth);
    $("#canvas").height(sizedWindowWidth);

    $("#canvasDraw").click(function(){
        var canvas = $("#canvas").get(0);

        if(canvas)
        {
            var canvasContext = canvas.getContext('2d');

            if(canvasContext)
            {
                canvasContext.canvas.width  = sizedWindowWidth;
                canvasContext.canvas.height = sizedWindowWidth;

                canvasContext.font = "bold 14px serif";
                canvasContext.fillText("Canvas is supported", 10, 20);
                canvasContext.fillStyle = "#ff0000";
                canvasContext.font = "italic 14px sans-serif";
                canvasContext.fillText("Hello Canvas", 30, 40);
                canvasContext.fillStyle = "#00ff00";
                canvasContext.fillRect(40, 50, 70, 20);
            }
        }
    });
}
*/


function speed_up_phonegap(){
	
	$('input[type="checkbox"]').bind('touchstart', function(e) {
	    if($(this).attr('checked') == false){
	        $(this).attr('checked', true);
	    } else {
	        $(this).attr('checked', false);
	    }
	    // code above toggles the checked attribute
	 
	    $(this).change();
	    // This manually throws the "change" event for the checkbox. Because we disabled the click event, the change event would not be raised.
	});
	
	$(document).bind("mobileinit", function()
			{
			    if (navigator.userAgent.indexOf("Android") != -1)
			    {
			        $.mobile.defaultPageTransition = 'none';
			        $.mobile.defaultDialogTransition = 'none';
			    }
			});
}



function hide_footer_on_input_focus(){
	/*
	$(":input").focus(function(){		
		$("div[data-role='footer']").hide();
	});
	*/
	
}



function set_config_parameters(){
	
	//window.globaldata["picture_repository"] = "http://dev.papitomarket.com/images";
	
}




$(document).ready(function() {
	
	      window["global"] = {};

	      
	      $("#results").live("swipeleft swiperight touchend",function (e){
			    e.preventDefault();	    	  
	      });
		
	       $.support.cors = true;
	       
	       
	       
	       initialize_slide_menu();
	       
	       set_config_parameters();
	   	   
	       //$("#results").touchScroll();
	       
	       //var scroller = new TouchScroll(document.querySelector("#results"), {elastic: true});
	       
	       
	       speed_up_phonegap();

	       hide_footer_on_input_focus();
	       
	       $('.ui-page').css('left','0px');
	       $("#menu ul").hide();
	       
	       
	       $( document ).ajaxStart(function() {
	    	   if ($("#progresspic").length <= 0){
	    	     $('div[data-role=\'content\']').append("<div id=\"progresspic\" class=\"z-index:-3;position:absolute;top: 50%;left: 50%;width:30px;height:30px\"><img src=\"images/progress.gif\"/></div>");
	    	   }
		   });
	       
	       $( document ).ajaxStop(function() {
	    	    $("#progresspic").remove();
     	   });
	       
	       $('#page1').fixedtoolbar({ tapToggle:false});
	       
	       
	       
	       $( document ).bind( 'mobileinit', function(){
		     $.mobile.loader.prototype.options.text = "loading";
		     $.mobile.loader.prototype.options.textVisible = false;
		     $.mobile.loader.prototype.options.theme = "a";
		     $.mobile.loader.prototype.options.html = "";
		   });
	
           $.mobile.defaultPageTransition = 'slide';
           
/*		   $("#sell,#sell1,#sell2").live('swipeleft swiperight',function(event){
	       event.preventDefault();
		   console.log(event.type);
	       if (event.type == "swipeleft") {
	    	   if ($('.ui-page-active').attr('id') == "mainmenu"){
	    		$(".showMenu").trigger("click");   
	    	   } else {
	                $.mobile.changePage("#" + next());
	    	   }
	        }
	        if (event.type == "swiperight") {
	                $.mobile.changePage("#" + prev());
	        }
	        event.preventDefault();

	    });*/
	});
