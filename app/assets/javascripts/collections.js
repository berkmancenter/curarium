$( function() {
  $( '.collections.show .delete-collection' ).click( function() {
    if ( !window.confirm( 'Are you sure you want to delete this collection and all works and annotations within?' ) ) {
      return false;
    }
  } );

  function extractExample( original, path ) {
    if ( original === null || path.length === 0 ) {
      return '';
    } else if ( typeof( original ) === 'object' && path[ 0 ].match( /^\d+$/ ) && !$.isArray( original ) ) {
      // array in path, single object in original, ignore the array
      path.splice( 0, 1 );
      return extractExample( original, path );
    } else if ( !original.hasOwnProperty( path[ 0 ] ) ) {
      return '';
    } else if ( path.length === 1 ) {
      return original[ path[ 0 ] ];
    } else if ( path.length > 1 ) {
      var subObj = original[ path[ 0 ] ];
      path.splice( 0, 1 );
      return extractExample( subObj, path );
    } else {
      // ?
      return '';
    }
  }

  function extractExamples() {
    var original = $( '.work-original' ).data( 'original' );

    $( '.form-active-fields .droppable' ).each( function( ) {
      var pathString = $( this ).find( 'input' ).val();
      console.log( pathString );
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

    $( '#sample_work_form' ).submit( function( ) {
      var sampleWorkFilter = $( '#sample_work_filter' ).val();

      if ( sampleWorkFilter ) {
        $.ajax( {
          url: $( this ).attr( 'action' ),
          data: {
            sample_work_filter: sampleWorkFilter
          },
          success: function( result ) {
            if ( !result || result.length == 0 ) {
              alert( 'We were unable to find records matching that name or metadata value.\n\nPlease check your search file name and try again.' );
            } else if ( result.length == 1 ) {
              $.ajax( {
                url: '/works/' + result[ 0 ].id + '/original',
                dataType: 'html',
                success: function( original ) {
                  $( '.work-original' ).replaceWith( original );
                  extractExamples();
                },
                error: function( ) {
                  alert( 'A record was found but something went wrong while trying to get the sample data for it. Please contact a Curarium admin.' );
                }
              } );
            } else {
              alert( 'Too many matching records found.\n\nPlease check your search file name and try again.' );
              //alert( JSON.stringify( result ) );
            }
          },
          error: function( ) {
            alert( 'Something went wrong while trying to find a matching record.\n\nPlease check your search file name and try again.' );
          }
        } );
      }

      return false;
    } );

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
