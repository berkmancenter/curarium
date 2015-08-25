$( function() {
  $( '.works.index' ).on( 'click', '.show-xhr .work-commands .show,.show-xhr .surrogates a', function() {
    window.open( $( this ).attr( 'href' ) );
    return false;
  } );

  $( '.works.index' ).on( 'click', '.show-xhr .close', function() {
    $.magnificPopup.instance.close();
    return false;
  } );

  if ( $( 'body.works.show' ).length ) {
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
  }

  // geomap
  $.geo.proj = null;

  var haveImage = false;

  var img = new Image();
  img.onload = function( ) {
    haveImage = true;
    var bboxMax = [ 0, 0, img.width, img.height ];
    $( '.work-canvas' ).geomap( 'option', 'bboxMax', bboxMax );
    setTimeout( function( ) { $( '.work-canvas' ).geomap( 'option', 'bbox', bboxMax ); }, 30 );
  };
  img.crossOrigin = 'anonymous';
  img.src = $('.work-canvas').data( 'imageUrl' );

  var viewCanvas = $( '<canvas width="128" height="128" />' );
  var viewContext = viewCanvas[0].getContext( '2d' );

  var map = $( '.work-canvas' ).geomap({
    bboxMax: [ 0, 0, 128, 128 ],
    axisLayout: 'image',
    tilingScheme: null,
    services: [ {
      type: 'shingled',
      src: function( view ) {
        if ( !haveImage ) {
          return '';
        }

        viewContext.canvas.width = view.width;
        viewContext.canvas.height = view.height; 
        viewContext.drawImage( img, view.bbox[0], view.bbox[1], $.geo.width( view.bbox ), $.geo.height( view.bbox ), 0, 0, view.width, view.height );

        return viewCanvas[0].toDataURL( 'image/png' );
      },
      style: {
        opacity: 0.99
      }
    } ]
  });
} );
