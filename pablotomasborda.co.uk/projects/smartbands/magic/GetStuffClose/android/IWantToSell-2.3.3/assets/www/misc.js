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

$(document).ready(function() {

           $.mobile.defaultPageTransition = 'slide';
		   $("#sell").live('swipeleft swiperight',function(event){
	       console.log(event.type);
	       if (event.type == "swipeleft") {
	           alert("left");
	           var prev = $("#fbloginpage",$.mobile.activePage);
	           if (prev.length) {
	               var prevurl = $(prev).attr("href");
	                console.log(prevurl);
	                $.mobile.changePage(prevurl);
	            }
	        }
	        if (event.type == "swiperight") {
	            alert("right");
	            var next = $("#sell1",$.mobile.activePage);
	            if (next.length) {
	                var nexturl = $(next).attr("href");
	                console.log(nexturl);
	                $.mobile.changePage(nexturl);
	            }
	        }
	        event.preventDefault();
	    });
	});
