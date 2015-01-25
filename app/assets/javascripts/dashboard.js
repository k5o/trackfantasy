var pathname = window.location.pathname;
var path = pathname.replace(/\//g, '');
var fromDate = getUrlParameter('from_date');
var toDate = getUrlParameter('to_date');
var site = getUrlParameter('site');
var sport = getUrlParameter('sport');

$(document).ready(function(){
  if ($('#nav-'+ path)) {
    $('#nav-'+ path).addClass('active');
  }

  $('form#filter').on('submit', function(){
    $('#js-filter-btn').hide().attr('disabled', 'disabled');
    $('.js-loader').show();
  })
});

function getUrlParameter(sParam) {
  var sPageURL = window.location.href;
  var urlParts = sPageURL.split('?').slice(1);
  if (urlParts.length > 0) {
    var sURLVariables = urlParts[0].split('&');

    for (var i = 0; i < sURLVariables.length; i++) {
      var sParameterName = sURLVariables[i].split('=');
      if (sParameterName[0] == sParam) { return sParameterName[1]; }
    }
  }
}

function fetchDashboardData() {
  $.ajax({
    url: '/dashboard/fetch_dashboard_data',
    data: {from_date: fromDate, to_date: toDate, site: site, sport: sport},
    type: 'GET',
  }).success(function(data){
    $('#dashboard').html(data);
  }).fail(function(data){
    $('.main-errors').append('Something went wrong, please make sure your date input is valid. <a href="/dashboard">Refresh</a>').show();
  });
}

function fetchGamesData() {
  $.ajax({
    url: '/dashboard/fetch_games_data',
    data: {from_date: fromDate, to_date: toDate, site: site, sport: sport},
    type: 'GET',
  }).success(function(data){
    $('#games').html(data);
  }).fail(function(data){
    $('.main-errors').append('Something went wrong, please make sure your date input is valid. <a href="/dashboard">Refresh</a>').show();
  });
}
