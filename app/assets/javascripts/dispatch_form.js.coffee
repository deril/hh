# hoverIntent | Copyright 2011 Brian Cherne
# http://cherne.net/brian/resources/jquery.hoverIntent.html
# modified by the jQuery UI team


$(document).ready -> 

  $(".accordion").accordion 
    heightStyle: "content",
    event: "mouseover"
