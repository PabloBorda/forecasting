  $("document").ready(function(){

	  //$.mobile.changePage($("#page1"));  

     window.globaldata = {picture_repository: "http://dev.getstuffclose.com/images/"};
     window.globaldata['order'] = [];
     $.support.cors = true;
     $.mobile.allowCrossDomainPages = true;
     

     $("#filters").hide();
     $("#but").hide();

    $("#search").click(function(e){
       clear();
     });
    $("#search").bind("valueset",function(e){
      $("#filters").show();
      window.globaldata['superproduct'] = $("#search").val();
      search_product();
      
    });

    $("#search").autocomplete({
      target: $('#productsuggest'), // the listview to receive results
      source: 'http://soa1.getstuffclose.com:9494/superproducts', // URL return JSON data
      link: '#', // link to be attached to each result
      minLength: 1 // minimum length of search string
    });

   
  });
