
/*
function validate_current(current_screen_number){
  
 switch current_screen_number{
   
   case 1:
     data().company = new Object;
     data().company.
     
     
     
     
   break;
     
 }
  
}
*/


function pack_input_data(current_screen_number){
  current_div = $("#middle div[class='item']").eq(current_screen_number).contents();
  objectname = $("#middle div[class='item']").eq(current_screen_number).attr("name").replace(/\s/g, "");
  inputs = current_div.find("input[type!='button'],textarea");
  if ((current_div.find("table[name='list']").length > 0) && ((window.global_data[objectname] == null)||(window.global_data[objectname].length <= 0))){
    window.global_data[objectname] = [];
    my_obj = {};

    $.each(inputs,function(k,v){
      my_obj[v.name] = "";
     });    
 
   
    /*rows = $("table[name='list'] tr");
    $.each(rows,function(k,v){
      row = {};
      tds = 
      
      row[
      window.global_data[objectname].push(
    });
    */
    
  } else {
    if (window.global_data[objectname] == null){
        window.global_data[objectname] = {};
        $.each(inputs,function(k,v){
           window.global_data[objectname][v.name] = v.value;
        });          
    }
  }
  

  return window.global_data[objectname];


  
  
  
}






function update_progress(direction){

  $("#progress tr td").css("background","red");
  current = $("#middle").scrollable().getIndex();

  if (direction == 'next'){
    pack_input_data(current);
    if (current == 3) {
        if ($("#image img").attr("src").indexOf("success") == -1) {
          alert("You need to pass the captcha test, to show you are a human."); 
 
       }
       current = 2;
    }

      if (current < 4){
        current = current + 1;
      } 
      else {
        if (current > 0){
          current = current - 1;
        }
      }
   
  
    current_div = $("#middle div[class='item']").eq(current).attr("name");
    $("#progresstable tr td:contains('" + current_div + "')").css("background-color","yellow");  
  }

}