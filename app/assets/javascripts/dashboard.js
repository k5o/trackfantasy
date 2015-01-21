$(document).ready(function(){
  var pathname = window.location.pathname
  var path = pathname.replace(/\//g, '')

  if ($('#nav-'+ path)) {
    $('#nav-'+ path).addClass('active');
  }

  $('form#filter').on('submit', function(){
    $('#js-filter-btn').hide().attr('disabled', 'disabled');
    $('.js-loader').show();
  })
})