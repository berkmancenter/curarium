$( function( ) {
  $( '.join-circle,.leave-circle' ).click( function( ) {
    $( this ).closest( 'form' ).submit();
    return false;
  } );

  $( '.delete-circle' ).click( function( ) {
    if ( confirm( 'Are you sure you want to delete this circle and all of the circle trays?' ) ) {
      $( this ).closest( 'form' ).submit();
    }
    return false;
  } );

  var circleCollectionsPopupHtml = $( '#circle-collections-popup' );
  $( '.circle-collections .createnew' ).click( function( ) {
    $.magnificPopup.open( {
      items: {
        src: circleCollectionsPopupHtml.css( 'display', 'inline-block' ),
        type: 'inline'
      }
    } );
    return false;
  } );

  $( '#circle-collections-popup .ccs-button' ).click( function( ) {
    var colBtn = $( this );
    colBtn.parent().find( 'input[name="circle[collections]"]' ).val( colBtn.data( 'collectionId' ) );
  } );
} );
