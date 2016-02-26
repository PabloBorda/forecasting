/**
 * @author papito
 */

$("#cardinfo").validate({
   rules: {
     first_name: { required: true,
                   minlength: 5 },
     last_name: { required: true,
                  minlength: 5 },
     number: { required: true,
     	     creditcard: true },
     verification_value: {required: true,
     	minlength: 3,
     	maxlength: 4 }
   },
   //errorLabelContainer: "#errorshere",
   errorClass: "errores",
   wrapper: "li"}
);





  function on_payment_success(){
  	//$("#show_results").dialog("close");     this doesnt work, i dunno why, but anyway I will do it as follows
	//close_input_card_dialog();
  	if ($("#thankyou:contains('Please check your')").size()==1){
  			  $("#paybutton").attr("disabled", false);				
			} else {
   			  $("#paybutton").attr("disabled", true);
			   send_case();
	          if ($("#hiddentype").val().indexOf("V") == 0) {
			    send_files();
			  }
			}
  
  }


function send_payment(){
	
	
			var options = {
		 		target: '#thankyou',
		 		success: on_payment_success
		 	};
		 	$("#cardinfo").ajaxForm(options);
		 	$("#cardinfo").trigger("submit");
			
			
	/*	jConfirm('Please verify that your Notice of Action is correct to proceed with payment. Are you sure to continue?', 'Confirm you Notice of Action', function(r) {
		 if (r) {
		 	var options = {
		 		target: '#thankyou',
		 		success: on_payment_success
		 	};
		 	
		 	$("#cardinfo").ajaxForm(options);
		 	$("#cardinfo").trigger("submit");
		
		 } else {
		 	$("#paybutton").attr("disabled", false);
			 $("#show_results").dialog("close");
			
		 }
        
    });

	*/
	
}


   function send_payment_case_files(){
   	
      send_payment();
	 
     }
	
		
	

