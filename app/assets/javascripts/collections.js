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
    $( '.collections.configure' ).on( 'dragstart', '[draggable]', function( e ) {
      e.originalEvent.dataTransfer.setData( 'dropData', JSON.stringify({
        path: $( this ).data( 'path' ),
        value: $( this ).data( 'value' )
      }) );
    } );

    $( '.collections.configure' ).on( 'dragenter dragover', '.droppable', function( e ) {
      e.preventDefault();
      return false;
    } );
    
    $( '.collections.configure' ).on( 'drop', '.droppable', function( e ) {
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

    $( '.collections.configure' ).on( 'ajax:success', '.form-active-fields', function( xhr, result ) {
      $( '.active-fields-save-date' ).text( $( result ).data( 'saved' ) ).parent().removeClass( 'hidden' );
    });

    $( '.collections.configure' ).on( 'ajax:success', '.form-add-field', function( xhr, result ) {
      $( '.form-active-fields' ).replaceWith( result );
    } );
    /*
    $( '.form-add-field button' ).click( function( ) { 
      console.log( $( '.form-add-field select' ).val( ) );
      $( '.form-active-fields' ).append( '<input type="hidden" name="' + <%= k %>" value="<%= v %>" class="field-input">
      
      
    } );
    */
  }
} );
