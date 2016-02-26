CC
function triggerUploadAction(){
  $("#logo-upload-form").trigger("submit");
  
}

function set_logo_upload_company_name(){
$("#logo-upload-company-name").val($("#overall-company-name").val());
}

$(document).ready(function() {
  
  var options = {
    target: "#logo-target"
  };
  $("#logo-upload-form").ajaxForm(options);
  
});
