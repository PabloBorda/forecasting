


function initialize(){
      
	  window["pics"] = [];
	  window["inputfocused"] = {};
	  window["pages"] = ["mainmenu", "sell", "sell1", "sell2"];
}

function set_global_options(){
	$.support.cors = true;
	$.mobile.allowCrossDomainPages = true;
	$.mobile.fixedToolbars.show(true);
}


function set_global_variables(){
	$("input").bind('change', function() {
		if(!window.inputfocused[this.name]) {
			window.global[this.name] = this.value;
			window.inputfocused[this.name] = true;
		}
	});

	$("input [name='file']").hide();

	$("textarea").bind('change', function() {
		window.global[this.name] = this.value;
	});

	
}

function clear_focused_fields(){
	$("input").bind('ontouchstart', function() {
		this.value = "";
	});	
	
	$("#description").bind('ontouchstart', function() {
		if(!window.inputfocused[this.name]) {
			this.value = "";
			window.inputfocused[this.name] = true;
		}
	});

	
}

function initialize_captcha(){
	var onSuccess = function(response) {
		$("#captcha").html(response);
	}
	$.ajax({
		type : "GET",
		url : "http://www.papitomarket.com:81/captcha",
		success : onSuccess
	});	
}


