
//function to show an emulated Facebook dialogue
function ShowFacebookDialogue(){
    if ($("#productname").val()!=""){
      $("#valid").empty();
      var selectedFriends = $("#jfmfs-container").data('jfmfs').getSelectedIds();  //list of selected friends
      var html_addrform = "<form name=\"addrs\">";
    
      for (var i=0;i<selectedFriends.length;i++){
      
        html_addrform = html_addrform +    
        "<table>" +
        "<TR>" +
          "<TD>" +
             "<img src='https://graph.facebook.com/" + selectedFriends[i].toString() + "/picture'/>" +
          "</TD>" +
          "<TD>" +
            "<table>" +
            "<TR>" +
              "<TD>" +
                "Address:" +
              "</TD>" +
              "<TD>" +
                "<input type=\"text\" name=\"addr" + selectedFriends[i].toString() + "\"" + "id=\"addr" + selectedFriends[i].toString() + "\"" + " size=\"25\"/>" +
              "</TD>" +
            "</TR>" +
            "<TR>" +
               "<TD>" +
                  "Appartment:" +
               "</TD>" +
               "<TD align=\"right\">" +
                  "<input id=\"cb" + selectedFriends[i].toString() + "\" type=\"checkbox\"/><input type=\"text\" id=\"ap" + selectedFriends[i].toString() + "\" name=\"ap" + selectedFriends[i].toString() + "\" size=\"4\" disabled=\"true\" />" +
               "</TD>" +
            "</TR>" +
        "</table>" +
      "</TD>" +
       "<TD>" +
         "<input type=\"button\" id=\"bt" + selectedFriends[i].toString() + "\" name=\"bt" + selectedFriends[i].toString() + "\" value=\"Choose product\" disabled=\"true\"/>" +
       "</TD>" +
     "</TR>" +
   "</table>";

      }
      html_addrform = html_addrform + "</form>";

    
      var dialogue = $("#dialogue").dialog({autoOpen: false, modal: true, draggable:false, resizable:false, bgiframe:true,position:'center',width: 530});
      //setup options for this dialogue
      $("#dialogue").dialog( "option", "title", 'Enter recepients addresses to send gift' );
      $("#dialogue").dialog({ buttons: { "Send Products": function() { $(this).dialog("close"); } }});
      $("#dialogue").html(html_addrform);
      $("#dialogue").dialog( "open" );
    
      $('input[name^="addr"]').autocomplete("/addrs");
     
      for (var i=0;i<selectedFriends.length;i++){
        $("#bt" + selectedFriends[i].toString()).attr("onclick","LetsChooseTheProduct('" + $("#productname").val().toString() + "','" + selectedFriends[i].toString() + "');");
	
	$("#addr" + selectedFriends[i].toString()).change(function(eventObject){
	  var uid = $(this).attr("id").replace("addr","");
	  if ($("#addr" + uid).val().toString().length>0){
	     $("#bt" + uid).attr("disabled",false);    
	  } else {
	     $("#bt" + uid).attr("disabled",true);
	  }
	});
	
	$("#cb" + selectedFriends[i].toString()).change(function(eventObject){
	   var uid = $(this).attr("id").replace("cb","");
           if ($(this).is(":checked")) {
	      $("#ap" + uid).attr("disabled",false);
	   } else {
	     $("#ap" + uid).attr("disabled",true);
	     $("#ap" + uid).val("");
	  }
});
      }
    
    } else {
      $("#valid").html("<font color=\"red\">Input the product you want to send, and select to whom.</font>");
    }
     $('#closeprods').dialog('open');
    /*
    $("#dialogue").bind( "dialogbeforeclose", function(event, ui) {
        alert("You can bind events as you normally would to JQuery UI dialogues.");
    });*/
} 
