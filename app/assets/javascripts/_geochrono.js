function FixMargin(left) {
    $(this).css("left", left);
}

$(document).ready(function( ) { 
  $("#left-button").click(function(){
        $(".chrono-info").css('margin-left','+=274px');
  });

   $("#right-button").click(function( ) {
        $(".chrono-info").css('margin-left','-=274px');

  });
});

$.ajax( {
  url: '/public/geochrono/query/' + $( '#works-geochrono' ).data( 'queryId' ) + '/data.json',
  success: function( ids ) {
    // render visualization
  
  var data = result;

  var firstWork = data[ 0 ];

  var firstWorkId = firstWork[ 0 ];

  var firstWorkDateStart = Date.parse( firstWork[ 1 ] );

  var firstWorkDateEnd = Date.parse( firstWork[ 2 ] );
  }
} );
