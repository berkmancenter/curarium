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
      var $this = $( this );
      $this.find( '.drop-data' ).html( dropData.path + '<br>( e.g., ' + dropData.value + ' )' );
      $this.find( 'input' ).val( JSON.stringify( dropData.path ) );

      var config = {};
      $.each( $( '.form-active-fields .field-input' ).serializeArray(), function() { config[ this.name ] = this.value } )
      $( '#collection_configuration' ).val( JSON.stringify( config ) );

      $this.parent( 'form' ).submit();
      return false;
    } );

    $( '.form-active-fields' ).on( 'ajax:success', function( xhr, result ) {
      $( '.active-fields-save-date' ).text( $( result ).data( 'saved' ) ).parent().removeClass( 'hidden' );
    });
  }
} );
