function LetsChooseTheProduct(prod,addr){
  var addr_from_input = $("#addr" + addr.toString()).val().toString();
  
  $.ajax({
    url: "/prods",
    data: {
      'addr': addr_from_input,
      'superprod': prod
    },
    success: function(data) {
    $('#closeprods').html(data);
   
}
  });
    
}
