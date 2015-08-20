$( function() {
  $( '.works.index' ).on( 'click', '.show-xhr .work-commands .show,.show-xhr .surrogates a', function() {
    window.open( $( this ).attr( 'href' ) );
    return false;
  } );

  $( '.works.index' ).on( 'click', '.show-xhr .close', function() {
    $.magnificPopup.instance.close();
    return false;
  } );

  $( '.works.show' ).on( 'click', '.nav-works a', function( ) {
    var panel = $( '#panel-' + $( this ).data( 'panel' ) );
    if ( panel.is( ':visible' ) ) {
      panel.hide();
    } else {
      $( '.panel-work' ).hide();
      panel.show();
    }
    return false;
  } );

  $( '.works.show' ).on( 'ajax:success', '.edit_work_set_cover', function( xhr, result ) {
    $( this ).replaceWith( result );
  } );
} );
