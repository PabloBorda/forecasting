$(document).ready(function() {
	$.support.cors = true;
	$(function() {
		var availableTags = [
			"ActionScript",
			"AppleScript",
			"Asp",
			"BASIC",
			"C",
			"C++",
			"Clojure",
			"COBOL",
			"ColdFusion",
			"Erlang",
			"Fortran",
			"Groovy",
			"Haskell",
			"Java",
			"JavaScript",
			"Lisp",
			"Perl",
			"PHP",
			"Python",
			"Ruby",
			"Scala",
			"Scheme"
		];
	$("#buscador").autocomplete({
			//source: 'http://soa1.papitomarket.com:9494/superproducts'
			target: $('#productsuggest'),
			source: '/superproducts',
			link: '#', // link to be attached to each result
        	minLength: 2 // minimum length of search string
	}); 
  });
});

