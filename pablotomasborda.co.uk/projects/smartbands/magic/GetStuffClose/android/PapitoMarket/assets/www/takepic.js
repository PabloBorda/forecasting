

    window["piccount"]=0;
  
    var pictureSource;   // picture source
    var destinationType; // sets the format of returned value 

    // Wait for PhoneGap to connect with the device
    //
    document.addEventListener("deviceready",onDeviceReady,false);

    // PhoneGap is ready to be used!
    //
    function onDeviceReady() {
        pictureSource=navigator.camera.PictureSourceType;
        destinationType=navigator.camera.DestinationType;
    }

   function setCurrent(pth){
 	  console.log("Image data: " + pth);
   	  largeImage = document.getElementById('largeImage');
   	  largeImage.style.display = 'block';
   	  largeImage.src = pth;
   	  
   }

  function fsFail(error) { 
    alert("failed with error code: " + error.code); 
  }
  
  // Called if something bad happens.
  // 
  function onFail(message) {
    alert('Failed because: ' + message);
  }


    function copiedFile(fileEntry) { 
            console.log("copied file: " + fileEntry.fullPath);
            
            // !!! assumes you have an img element on page with id=largeImage 
            var fullPath = fileEntry.fullPath;
     
            var smallImage = "<td onclick=\"setCurrent('" + fullPath + "');\"><img style=\"width:60px;height:60px;\" id=\"thumb" + window.piccount.toString() + "\" src=\"" + fullPath + "\"/></td>";
            //console.log("Small image: " + smallImage);
      
      
            $("#gallery").append(smallImage).trigger('create');
            
            var fread = new FileReader();
             
                 
            //$("#prod").append("<input style=\"display: none;\" type=\"file\" name=\"pic" + window.piccount.toString() + "\" value=\"" + fullPath + "\" /> ").trigger('create');
            //$("#prod").append("<input type=\"file\" name=\"pic" + window.piccount.toString() + "\" value=\"" + fullPath + "\" /> ").trigger('create');
      
            // Unhide image elements
            //
            //smallImage.style.display = 'block';
      
            var largeImage = document.getElementById('largeImage');

            // Unhide image elements
            //
            largeImage.style.display = 'block';

            // Show the captured photo
            // The inline CSS rules are used to resize the image
            //
            largeImage.src = fullPath;
      
            window.piccount = window.piccount + 1;
      
    } 
   
    // Called when a photo is successfully retrieved
    //
  function onPhotoDataSuccess(imageData) {
  	    	    	
    // Uncomment to view the base64 encoded image data
    // console.log(imageData);

    // Get image handle
    //

            var imgFileName = imageData.substr(imageData.lastIndexOf('/')+1); 
            var imgPath = "tmp/" + imgFileName; 
            //console.log("imgFileName value: " + imgFileName); 
            //window.global['lastpic'] = imgPath;

            var gotFileEntry = function(fileEntry) { 
                console.log("got image file entry: " + fileEntry.fullPath); 
                //window.global['lastpic'] = fileEntry.fullPath;
                var gotFileSystem = function(fileSystem){ 
                    // copy the file 
                    fileEntry.copyTo(fileSystem.root, null,copiedFile, fsFail); 
                }; 
                // get file system to copy or move image file to 
                window.requestFileSystem(LocalFileSystem.PERSISTENT,0, gotFileSystem, fsFail); 
            }; 
      window.resolveLocalFileSystemURI(imageData, gotFileEntry,fsFail);
      
      window.pics.push(imageData);   
    }

     // A button will call this function
    //
    function capturePhoto() {
    	console.log("Function run: capturePhoto");
      // Take picture using device camera and retrieve image as base64-encoded string
       navigator.camera.getPicture(onPhotoDataSuccess, onFail, { quality: 50, 
                                        destinationType: destinationType.FILE_URI }); 

    } 
    

    // A button will call this function
    //
    function capturePhotoEdit() {
    	console.log("Function run: capturePhotoEdit");

      // Take picture using device camera, allow edit, and retrieve image as base64-encoded string  
      navigator.camera.getPicture(onPhotoDataSuccess, onFail, { quality: 20, allowEdit: true }); 
    }

    
    function onPhotoURISuccess(imageData){
    	
    	
    	
    }
    
    
    // A button will call this function
    //
    function getPhoto(source) {
      console.log("Function run: getPhoto");

      // Retrieve image file location from specified source
      navigator.camera.getPicture(onPhotoURISuccess, onFail, { quality: 50, 
        destinationType: destinationType.FILE_URI,
        sourceType: source });
    }
   

