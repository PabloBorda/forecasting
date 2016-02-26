C/**
 * @author Pablo Tomas Borda Di Berardino
 * @email pablo.tomas.borda@hotmail.com
 */

 
 function validate_smaller_than(my_str,size){
   return (my_str.val().length < size); 		
 }
 
 function validate_bigger_than(my_str,size){
 	return (my_str.val().length > size);
 }
 
 function validate_required(my_str){
 	return ((my_str.val()!="") && (my_str.val()!=null));
 }

 function validate_is_number(my_str){
 	return (parseFloat(my_str.val())!="NaN");
 
 }
 
 function validate_numbers_between(num1,between_num,and_between){ 	
	var fnum1 = parseFloat(num1.val());
 	return (validate_is_number(num1) && (fnum1 >= between_num) && (fnum1 <= and_between));
 }
	
