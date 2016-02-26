function onRequest(request, sender, sendResponse) {
  // The number of matches is sent in the request - pass it to the
  // infobar.
   
  //alert("The entries are: " + request.stringify());

  // Return nothing to let the connection be cleaned up.
  //sendResponse({});
  sendResponse("This background checks form entries on database, and return values to contentscript");
};

// Listen for the content script to send a message to the background page.
chrome.extension.onRequest.addListener(onRequest);