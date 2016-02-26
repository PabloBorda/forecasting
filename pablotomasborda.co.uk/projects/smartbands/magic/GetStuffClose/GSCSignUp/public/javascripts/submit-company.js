function submitall(){

  $.ajax({
    url: '/newcompanyws',
    data: {'json': window.global_data},
    type: 'post'});
    alert("Thanks for the data...  generating demo");
}


$(document).ready(
  
  function() {
   $("#create-demo-button").click(function(){
     
     
 
     

         $('#demo-answer').load('/create_demo #like_product');
   }); 
    
  }
);
