window['Menu'] = {
  menuitems: [],
  buy : function (){
	  $.mobile.changePage($("#page1"));
	  $(".ui-page-active").css({marginLeft: "30px"});
	  initialize_variables();
	  set_global_options();
	  input_fields_clear();
	  set_search_handlers();
  },
  sell : function(){	  
      $.mobile.changePage("#sell");
      $("a.showMenu").trigger('click');
      initialize();
      set_global_options();
      set_global_variables();
      clear_focused_fields();
      initialize_captcha();     
  },
  tagfeeds : function(){
	  $.mobile.changePage($("#tagfeeds"));	  
	  $("a.showMenu").trigger('click');
  },
  log : function(){
	  $.mobile.changePage($("#log"));  
	  $("a.showMenu").trigger('click');
  },
  browse : function(){
	  $.mobile.changePage($("#browse"));
	  $("a.showMenu").trigger('click');
  },
  buycredit : function(){
	  $.mobile.changePage($("#buycredit"));
	  $("a.showMenu").trigger('click');
  },
  findbybarcode : function(){
	  $.mobile.changePage($("#findbybarcode"));
	  $("a.showMenu").trigger('click');
  },
  exit: function(){
	  $.mobile.changePage($("#exit"));
	  $("a.showMenu").trigger('click');
  }
  };