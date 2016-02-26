       
            //if ((typeof cordova == 'undefined') && (typeof Cordova == 'undefined')) alert('Cordova variable does not exist. Check that you have included cordova.js correctly');
            //if (typeof CDV == 'undefined') alert('CDV variable does not exist. Check that you have included cdv-plugin-fb-connect.js correctly');
            //if (typeof FB == 'undefined') alert('FB variable does not exist. Check that you have included the Facebook JS SDK file.');
            
            FB.Event.subscribe('auth.login', function(response) {
            	               //console.log(response);
                                alert('auth.login event ' + response.toString());
                               });
            
            FB.Event.subscribe('auth.logout', function(response) {
                               alert('auth.logout event');
                               });
            
            FB.Event.subscribe('auth.sessionChange', function(response) {
                               alert('auth.sessionChange event');
                               });
            
            FB.Event.subscribe('auth.statusChange', function(response) {
                               alert('auth.statusChange event');
                               });
            
            /*function getSession() {
                alert("session: " + JSON.stringify(FB.getSession()));
            }
            */
            function getLoginStatus() {
                FB.getLoginStatus(function(response) {
                                 // alert(JSON.stringify(response.data));
                                  if (response.status == 'connected') {
                                	$.mobile.changePage($("#sell"));  
                                	update_sell();
                                    //$("#you").html("<label>Welcome Pablo!</label>");

                                  //alert('logged in');
                                  } else {
                                   $("#you").html("<label>Welcome " + session.toString() + "</label>");
                                   //alert('not logged in');
                                  }
                                  });
            }
            var friendIDs = [];
			var fdata;
            function me() {
                FB.api('/me/friends', { fields: 'id,name,picture,email' },  function(response) {
                       if (response.error) {
                       alert(JSON.stringify(response.error));
                       } else {
                         var data = document.getElementById('data');
					     fdata=response.data;
					     console.log("fdata: "+fdata);
					     var count = 0;
	                       response.data.forEach(function(item) {
                               var d = document.getElementById('people');
                               d.innerHTML = "<img src="+item.picture+"/>"+item.name;
                               data.appendChild(d);
                               });/*
                         response.data.forEach(function(item) {
                    	                       var row = "<tr><td><input type=\"checkbox\" name=\"f" + count.toString() + "\"/></td>" +
                    	                       "<td><img src=\"" + item.picture + "\"/></td><td>" + item.name + "</td></tr>";
                    	                       $("#people").append(row);
                                               });*/
                       }
					var friends = response.data;
					console.log(friends.length); 
					for (var k = 0; k < friends.length && k < 200; k++) {
				        var friend = friends[k];
				        var index = 1;

				        friendIDs[k] = friend.id;
				        //friendsInfo[k] = friend;
					}
					console.log("friendId's: "+friendIDs);
                       });
            }
            
            function logout() {
                FB.logout(function(response) {
                	$.mobile.changePage($("#page0"));
                          //alert('logged out');
                          });
            }
            
            function login() {
                FB.login(
                         function(response) {
                         if (response.session) {
                           $.mobile.changePage($("#sell"));
                           
                           //alert('logged in ' + response.session );
                         } else {
                        	 getLoginStatus();
                        	 //$.mobile.changePage($("#page1"));
                          //$.mobile.changePage($("#page1"));
                          //$("#you").html("<label>Welcome " + session.toString() + "</label>");
                         //alert('not logged in ' + response.session);
                         }
                         },
                         { scope: "email,publish_stream" }
                         );
            }
			
			
			function facebookWallPost() {				
				$("#progressdetail").append("<label>Post to Facebook Wall</label>");
				var params = {};
				params['message'] = window.global.meobject.name + " is selling " + $("#name").val() + " on GetStuffClose.com. Check out his product!";
				params['name'] = 'GetStuffClose.com';
				params['description'] = window.global.description;
				params['link'] = 'http://www.google.com';
				params['picture'] = 'http://soa1.getstuffclose.com/images/pic0_' + window.global.time + '.jpg';
				params['caption'] = $("#name").val();
				console.log("image for facebook is: " + params['picture']);
				/*	
				  FB.ui({
					    method: 'feed',
					    name: 'GetStuffClose.com',
					    caption: window.global.description,
					    description: window.global.meobject.name + " is selling " + $("#name").val() + " by using GetStuffClose.com. Check out his product!",
					    link: 'http://apps.facebook.com/mobile-start/',
					    picture: 'http://fbrell.com/f8.jpg',
					    actions: [{ name: 'Get Started', link: 'http://apps.facebook.com/mobile-start/' }],
					  }, 
					  function(response) {
					    console.log('publishStory UI response: ', response);
					  });
				
				*/
				FB.api('/me/feed', 'post', params, function(response) {
				  console.log(JSON.stringify(response));
				  if (!response || response.error) {
				    alert('Error occured');
				  } else {
					  $("#progressdetail").append("<label>... ... ... ... ... ...  OK</label><br/>");
				  }
				});
				
				
			}
            
			function publishStoryFriend() {
				randNum = Math.floor ( Math.random() * friendIDs.length ); 

				var friendID = friendIDs[randNum];
				if (friendID == undefined){
					alert('please click the me button to get a list of friends first');
				}else{
			    	console.log("friend id: " + friendID );
			        console.log('Opening a dialog for friendID: ', friendID);
			        var params = {
			        	method: 'feed',
			            to: friendID.toString(),
			            name: 'Facebook Dialogs',
			            link: 'https://developers.facebook.com/docs/reference/dialogs/',
			            picture: 'http://fbrell.com/f8.jpg',
			            caption: 'Reference Documentation',
			            description: 'Dialogs provide a simple, consistent interface for applications to interface with users.'
			     	};
					FB.ui(params, function(obj) { console.log(obj);});
			    }
			}
			
			
  	        function update_sell(){
  				FB.api('/me',{fields: 'id,name,picture,email'},function(response){
					$("#fbpic").html('<img src="' + response.picture + '"/>');
					$("#wellcome").html('<h5>Wellcome ' + response.name + ' sell your stuff here!</h5>');
					window.global["meobject"] = response;					
				});
  				
  				//FB.api('/me/?fields=currency', function(data) {
  				 // if (!data || data.error) {
  				    //alert("Could not retrieve currency");
  				// } else {
  				//	window.global["currency"] = data;
  				//	console.log("currency information: " + JSON.stringify(data));
  				    // use data.currency.user_currency, data.currency.currency_exchange_inverse, 
  				    // and data.currency.currency_offset to set prices in your store
  				//  }
  				//	});
  				
  				
  				
            }
		 	

            document.addEventListener('deviceready', function() {
                                      try {
                                      //alert('Device is ready! Make sure you set your app_id below this alert.');
                                      FB.init({ appId: "393714530678728", nativeInterface: CDV.FB, useCachedDialogs: false , channelURL: "http://soa1.getstuffclose.com"});
                                      document.getElementById('data').innerHTML = "";
                                      } catch (e) {
                                      //alert(e);
                                      }
                                      }, false);
