function clear_productname(){
 $("#productname").val(""); 
 $("#valid").empty();
 $("#productname").attr("onfocus","");
}

$(document).ready(
  function(){            
    
    $("#productname").autocomplete("/whatproduct");    
}); 
