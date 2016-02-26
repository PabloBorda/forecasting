$(document).ready(function(){
	
	
  //$("#like_product").hide();
  
  
  
  $("#create-demo-button").click(function(){
  	
  	
  	
	     $("#demo-answer").dialog({
			resizable: false,
			height:300,
			modal: true,
			buttons: {
				"Yes!": function() {
					$( this ).dialog( "close" );
					$("#ilikeit").dialog({position: 'top'});
    				$('#ilikeit').load("/payment/input_card_data");
				},
				"No": function() {
					$( this ).dialog( "close" );
				}
			}
		});
	
  });
  
  
  
  
});