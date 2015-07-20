function FixMargin(left) {
    $(this).css("left", left);
}

$(document).ready(function( ) { 
  $("#left-button").click(function(){
        $(".chrono-info").css('margin-left','+=160px');
  });

   $("#right-button").click(function( ) {
        $(".chrono-info").css('margin-left','-=160px');

  });
});
