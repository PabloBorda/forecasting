function addpic(){
	
	if ($("#selectmenu1").val()=="camera"){
		capturePhoto();
	} else {
		getPhoto(pictureSource.PHOTOLIBRARY);
	}
}