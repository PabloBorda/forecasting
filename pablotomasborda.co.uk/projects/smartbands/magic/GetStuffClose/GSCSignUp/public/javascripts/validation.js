
var validator = {
  advisor: null,
  email_message: "<p>Email is wrong.</p>";
  email: function (addr){
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\
".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA
-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if !(re.test(addr)){
	  if (advisor != null){
	    this.advisor.html(email_message); 
	  } else {
	    alert(email_message);
	  }
	  return false;
	} else {
	  return true;
	}
  },
  required_message: "<p> Field required </p>",
  required: function(val){
    if (value==""){
      if (this.advisor != null) {
        this.advisor.html(required_message);
      } else {
	alert(required_message);
      }
      
      return false;
    } else {
      return true;
      
    }
  },
  passwords_message: "<p> Passwords are diferent </p>",
  passwords: function (p,p1){
   if (p != p1) {
     if (this.advisor != null) {
        this.advisor.html(passwords_message);
      } else {
	alert(passwords_message);
      }
     return false;
   } else {
     return true;
   }
    
  }

  
};




function validate_company(company){
  
  return (validator.required(company.password) &&
          validator.required(company.repeatpassword) &&
          validator.passwords(company.password,company.repeatpassword) &&
          validator.required(company.email) &&
          validator.email(company.email) &&
          validator.required(company.mobile));
  
}