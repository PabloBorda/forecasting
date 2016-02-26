		FB.init({appId: '244377358952042', cookie: true});

		FB.getLoginStatus(function(response) {
		    if (response.session) {
		      init();
		    } else {
		      // no user session available, someone you dont know
		    }
		});


		function login() {
		    FB.login(function(response) {
			if (response.session) {
			    init();
			} else {
			    alert('Login Failed!');
			}
		    });
		}

		function init() {
		  FB.api('/me', function(response) {
		      $("#username").html("<img id='profpic' src='https://graph.facebook.com/" + response.id + "/picture?type=large'/>");
		      $("#jfmfs-container").jfmfs({ max_selected: 15, max_selected_message: "{0} of {1} selected"});
		      $("#logged-out-status").hide();
		    // $("#show-friends").show();
  
		  });
		}              


	      /* $("#show-friends").live("click", function() {
		    var friendSelector = $("#jfmfs-container").data('jfmfs');             
		    $("#selected-friends").html(friendSelector.getSelectedIds().join(', ')); 
		});*/                  

 
