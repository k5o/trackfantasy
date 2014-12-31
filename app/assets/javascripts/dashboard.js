$(document).ready(function(){
  var path = window.location.pathname.slice(1);

  if ($('#nav-'+ path)) {
    $('#nav-'+ path).addClass('active');
  }
})