$(document).ready(function (){
  $("#js-learn-more").click(function() {
    $('html, body').animate({
      scrollTop: $("#js-details").offset().top
    }, 600);
    return false;
  });

  $("#js-cta").click(function() {
    $('html, body').animate({
      scrollTop: $("#js-pricing").offset().top
    }, 600);
    return false;
  });
});