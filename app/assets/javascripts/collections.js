$( function() {
  $( '.collections.show .delete-collection' ).click( function() {
    if ( !window.confirm( 'Are you sure you want to delete this collection and all works and annotations within?' ) ) {
      return false;
    }
  } );

  function extractExample( original, path ) {
    if ( path.length === 1 ) {
      return original[ path[ 0 ] ];
    } else if ( path.length > 1 ) {
      var subObj = original[ path[ 0 ] ];
      path.splice( 0, 1 );
      return extractExample( subObj, path );
    }
  }

  function extractExamples() {
    var original = $( '.work-original' ).data( 'original' );

    $( '.form-active-fields .droppable' ).each( function( ) {
      var pathString = $( this ).find( 'input' ).val();
      if ( pathString.length ) {
        var path = JSON.parse( pathString.replace( /\*/g, '0' ) );
        var ex = extractExample( original, path );
        $( this ).find( '.example' ).text( '( e.g., ' + ex + ' )' );
      }
    } );
  }

  function replaceActiveFields( result ) {
    $( '.form-active-fields' ).replaceWith( result );
    extractExamples();
    $( '.active-fields-save-date' ).text( $( result ).data( 'saved' ) ).parent().removeClass( 'hidden' );
  }

  function saveConfig( ) {
    var form = $( '.form-active-fields' );

    var config = {};
    $.each( form.find( '.field-input' ).serializeArray(), function() {
      config[ this.name ] = ( this.value.length ? JSON.parse( this.value ) : '' );
    } );
    $( '#collection_configuration' ).val( JSON.stringify( config ) );

    form.submit();
  }

  if ( $( '.collections.new' ).length ) {
    /*
    $( window ).on( 'beforeunload', function( e ) {
      return 'Data you have entered will not be saved.';
    } );
    */

    //introJs().start();
  }

  if ( $( '.collections.configure' ).length ) {

    // first load
    extractExamples();

    $( '.collections.configure' ).on( 'dragstart', '[draggable]', function( e ) {
      e.originalEvent.dataTransfer.setData( 'dropData', $( this ).attr( 'data-path' ) );
    } );

    $( '.collections.configure' ).on( 'dragenter dragover', '.droppable', function( e ) {
      e.preventDefault();
      return false;
    } );
    
    $( '.collections.configure' ).on( 'drop', '.droppable', function( e ) {
      e.preventDefault();

      var dropData = e.originalEvent.dataTransfer.getData( 'dropData' );
      var $this = $( this );
      $this.find( 'input' ).val( dropData );

      saveConfig();
      return false;
    } );

    $( '.collections.configure' ).on( 'ajax:success', '.form-active-fields', function( xhr, result ) {
      replaceActiveFields( result );
    });

    $( '.collections.configure' ).on( 'click', '.form-add-field button', function( ) {
      var val = $( this ).parent().find( '#collection_field' ).val();
      if ( val !== '' ) {
        $( '.form-add-field' ).append( '<input type="hidden" name="' + val + '" value="" class="field-input">' );
        saveConfig();
      }
    } );

    $( '.collections.configure' ).on( 'ajax:success', '.form-add-field', function( xhr, result ) {
      replaceActiveFields( result );
    } );

    $( '.collections.configure' ).on( 'click', '.remove-field', function( ) {
      $( this ).parent().remove();
      saveConfig();
    } );

    $( '.collections.configure' ).on( 'click', '.btn-new-field', function( ) {
      var fieldName = null;

      var promptText = ' It will improve search and visualizations.\n\nNote: the name you choose will be visible to all users who create collections.';

      if ( $( '#collection_field option' ).length == 1 ) {
        promptText = 'Please create field names that may be useful across collections.' + promptText;
      } else {
        promptText = 'If possible, please use one of the existing fields.' + promptText;
      }

      fieldName = prompt( promptText );

      if ( fieldName ) {
        $.ajax( {
          url: '/collection_fields',
          method: 'POST',
          data: {
            'collection_field[display_name]': fieldName
          }
        } ).done( function( ) {
          saveConfig();
        } ).fail( function( result ) {
          alert( JSON.stringify( result ) );
        } );
      }
    } );
  }
} );
