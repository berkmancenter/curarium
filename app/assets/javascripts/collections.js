$( function() {
  $( '.collections.show .delete-collection' ).click( function() {
    if ( !confirm( 'Are you sure you want to delete this collection and all works and annotations within?' ) ) {
      return false;
    }
  } );

  if ( $( '.collections.new' ).length ) {
    /*
    $( window ).on( 'beforeunload', function( e ) {
      return 'Data you have entered will not be saved.';
    } );
    */

    //introJs().start();
  }

  if ( $( '.collections.configure' ).length ) {
    $( '[draggable]' ).on( 'dragstart', function( e ) {
      e.originalEvent.dataTransfer.setData( 'dropData', JSON.stringify({
        path: $( this ).data( 'path' ),
        value: $( this ).data( 'value' )
      }) );
    } );

    $( '.droppable' ).on( 'dragenter dragover', function( e ) {
      e.preventDefault();
      return false;
    } ).on( 'drop', function( e ) {
      e.preventDefault();

      var dropData = JSON.parse( e.originalEvent.dataTransfer.getData( 'dropData' ) );
      $( this ).find( '.drop-data' ).html( dropData.path + '<br>' + dropData.value );

      return false;
    } );
  }
} );
