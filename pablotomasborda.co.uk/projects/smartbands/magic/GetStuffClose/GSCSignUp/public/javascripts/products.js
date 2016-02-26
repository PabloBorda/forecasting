function delete_product(product_id){
  if (window.global_data.Products != null){
    window.global_data.Products.splice(product_id,1);
    $("#productstable tr").eq(product_id).remove();
  }

  
}


$(document).ready(function (){
  $("#add-to-products").click(function (){
    var i=$("#productstable tr").size()-1; 
   
    $("#productstable").append("<tr><td>" + $("#name").val() + "</td>" + "<td>" + $("#price").val() + "</td><td>Preview</td><td><a href=\"#\"><img src=\"/images/delete_icon.gif\" onClick=\"delete_product("+ i +  ");\"></a></td></tr>");

    current_div = $("#middle div[class='item']").eq(3).contents();
    
    inputs = current_div.find("input[type!='button'],textarea");
    
    
    my_obj = {};
    $.each(inputs,function(k,v){
      my_obj[v.name] = v.value;
     });    
    
    
    if (window.global_data.Products == null){
      window.global_data.Products = [];
    }
    window.global_data.Products.push(my_obj);

  });
  
  
  
});
