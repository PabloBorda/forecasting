function initialize_gallery(){
	
	
	
	(function(window, $, PhotoSwipe){
		

			
			$('div.gallery-page')
				.live('pageshow', function(e){
					
					var 
						currentPage = $(e.target),
						options = {},
						photoSwipeInstance = $("ul.gallery a", e.target).photoSwipe(options,  currentPage.attr('id'));
						
					return true;
					
				})
				
				.live('pagehide', function(e){
					
					var 
						currentPage = $(e.target),
						photoSwipeInstance = PhotoSwipe.getInstance(currentPage.attr('id'));

					if (typeof photoSwipeInstance != "undefined" && photoSwipeInstance != null) {
						PhotoSwipe.detatch(photoSwipeInstance);
					}
					
					return true;
					
				});
			
	
	}(window, window.jQuery, window.Code.PhotoSwipe));
	
	
}