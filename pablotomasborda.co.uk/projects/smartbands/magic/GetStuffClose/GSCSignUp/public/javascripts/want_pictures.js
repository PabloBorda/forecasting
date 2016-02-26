$(document).ready(function(){
	
	$("#want-pictures").click(function(){
       if ($("#want-pictures:checked") != null){
		$("#pinfo").append("<tr id=\"quieropic\"><td>Choose the product picture: <input width=\"30\"type=\"file\" name=\"productpic\"/></td></tr>");
	   } else {
	   	$("#quieropic").remove();
	   }
	
	});
});
