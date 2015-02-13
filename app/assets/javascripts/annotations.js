$( function( ) {
  $( '#work_annotations .annotation-thumbnail' ).click( function( ) {
    var thumbnail = $( this );

    $.get( thumbnail.attr( 'href' ), function( popupHtml ) {
      $.magnificPopup.open( {
        items: {
          src: popupHtml,
          type: 'inline'
        }
      } );
    } );

    return false;
  } );

  $( '.works.show' ).on( 'click', '.annotation-xhr .popup-commands .close', function() {
    $.magnificPopup.instance.close();
    return false;
  } );

  $( '.works.show' ).on( 'click', '.annotation-xhr .delete-annotation', function() {
    if ( confirm( 'Are you sure you want to delete this annotation?' ) ) {
      $( this ).closest( 'form' ).submit();
    }
    return false;
  } );

  $( '.delete-annotation' ).click( function( ) {
    if ( confirm( 'Are you sure you want to delete this annotation?' ) ) {
      $( this ).closest( 'form' ).submit();
    }
    return false;
  } );
} );
