$( function() {
  // no longer needed after waku integration
  if ( $( '.spotlight_viewedit' ).length ) {
    window.spotlights.components = [];
    window.trays.show();
    window.spotlights.create();
  }

  $( '.trays.index' )
  .on( 'click', '[data-action]', function( ) {
    var action = $( this ).data( 'action' );
    if ( action === 'destroy' ) {
      if ( confirm( 'Delete this tray?' ) ) {
        $.ajax( {
          type: 'DELETE',
          url: $( this ).attr( 'href' ),
        } )
        .done( function( result ) {
          window.location.reload();
        } );
      }
    }

    return false;
  } );

  var trayPopupHtml = $( '.tray-popup' );

  $( '.trays.show .tray-item' )
  .on( 'click', '[data-action]', function( ) {
    var action = $( this ).data( 'action' );
    if ( action === 'destroy' ) {
      if ( confirm( 'Remove this item from the tray?' ) ) {
        $.ajax( {
          type: 'DELETE',
          url: '/tray_items/' + $( this ).closest( '.commandnail' ).data( 'trayItemId' ),
        } )
        .done( function( result ) {
          window.location.reload();
        } );
      }
    } else {
      $.ajax( {
        url: window.location.href + '/..',
        data: {
          popup_action: action,
          popup_action_item_id: $( this ).closest( '.commandnail' ).data( 'trayItemId' )
        }
      } )
      .done( function( popupHtml ) {
        $.magnificPopup.open( {
          items: {
            src: popupHtml,
            type: 'inline'
          }
        } );
      } );
    }
  } );

  $( '.works.index' )
  .on( 'click', '.work-commands .tray', function( ) {
    var workImage = $( this ).closest( '.work-image' );

    $.ajax( {
      url: '/trays',
      data: {
        popup_action: 'add',
        popup_action_item_type: workImage.data( 'actionItemType' ),
        popup_action_item_id: workImage.data( 'actionItemId' )
      }
    } )
    .done( function( popupHtml ) {
      $.magnificPopup.open( {
        items: {
          src: popupHtml,
          type: 'inline'
        }
      } );
    } );
    return false;
  } );


  $( '.works.index, .works.show' )
  .on( 'click', '.tray-popup-button', function( ) {
    var popup = $( this ).closest( '.tray-popup' );
    $.ajax( {
      type: 'POST',
      url: '/tray_items',
      data: {
        'tray_item[tray_id]': $( this ).data( 'trayId' ),
        'tray_item[image_id]': popup.data( 'actionItemId' )
      }
    } )
    .done( function( result ) {
      popup.closest( '.tray_info' ).find( '.checkbox_hack' ).click( );
      $.magnificPopup.instance.close();
    } )
    .fail( function( result ) {
      alert( result );
    } );
    return false;
  } )
  .on( 'submit', '.new_tray', function( e ) {
    var $form = $( this );
    $.ajax( {
      type: 'POST',
      url: $form.attr( 'action' ),
      data: $form.serialize()
    } )
    .done( function( popupHtml ) {
      if ( $( '.mfp-content' ).length ) {
        $.magnificPopup.instance.close();
        $.magnificPopup.open( {
          items: {
            src: popupHtml,
            type: 'inline'
          }
        } );
      } else {
        $form.closest( '.expand_tray' ).html( popupHtml );
      }
    } );
    return false;
  } );



  $( '.trays.show' )
  .on( 'click', '.tray-popup-button', function( ) {
    var actionTypes = {
      move: 'PUT',
      copy: 'POST'
    };

    var popup = $( this ).closest( '.tray-popup' );
    $.ajax( {
      type: actionTypes[ popup.data( 'action' ) ],
      url: '/tray_items/' + popup.data( 'actionItemId' ) + '/' + popup.data( 'action' ),
      data: {
        'tray_item[tray_id]': $( this ).data( 'trayId' )
      }
    } )
    .done( function( result ) {
      $.magnificPopup.instance.close();
      window.location.reload();
    } )
    .fail( function( result ) {
      $.magnificPopup.instance.close();
      alert( result );
    } );
  } )
  .on( 'submit', '.new_tray', function( e ) {
    var $form = $( this );
    //alert( $( this ).serialize() );
    $.ajax( {
      type: 'POST',
      url: $form.attr( 'action' ),
      data: $form.serialize()
    } )
    .done( function( popupHtml ) {
      $.magnificPopup.instance.close();
      $.magnificPopup.open( {
        items: {
          src: popupHtml,
          type: 'inline'
        }
      } );
      //$form.closest( '.mfp-content' ).html( result );
    } );
    return false;
  } );
} );
