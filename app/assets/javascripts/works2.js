$( function() {
  $( '.works.index' ).on( 'click', '.show-xhr .work-commands .show,.show-xhr .surrogates a', function() {
    window.open( $( this ).attr( 'href' ) );
    return false;
  } );

  $( '.works.index' ).on( 'click', '.show-xhr .close', function() {
    $.magnificPopup.instance.close();
    return false;
  } );

  if ( $( '.works.show' ).length ) {
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

    $( window ).resize( function() {
      var xs = $(this).width() < 768;
      $( '.nav-works' ).toggleClass( 'nav-stacked', !xs );
      $( '.footer' ).toggleClass( 'hidden', xs );
    } ).trigger('resize');

    // geomap
    $.geo.proj = null;

    var haveImage = false;
    var showAnnotations = true;
    var timeoutMove = null;

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

    var map = $( '.work-canvas' ).geomap( {
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
      }, {
        type: 'shingled',
        src: '',
        id: 'annotations-service'
      } ],

      move: function( e, geo ) {
        if ( timeoutMove ) {
          clearTimeout( timeoutMove );
          timeoutMove = null;
        }

        if ( showAnnotations ) {
          timeoutMove = setTimeout( function( ) {
            var annotations = annotationsService.geomap( 'find', geo, 1 );

            if ( annotations.length ) {
              var popupHtml = '<ul class="media-list media-list-annotations">';
              $.each( annotations, function( ) {
                popupHtml += $( '#' + this.properties.id ).html();
              } );
              popupHtml += '</ul>';

              var position = map.geomap( 'toPixel', geo.coordinates );
              $( '.annotations-popup' ).html( popupHtml ).css( {
                left: position[ 0 ],
                top: position[ 1 ]
              } ).removeClass( 'hidden' );
            } else {
              $( '.annotations-popup' ).addClass( 'hidden' );
            }
          }, 334 );
        }
      }
    } );

    var annotationsService = $( '#annotations-service' ).geomap( 'option', 'shapeStyle', {
      color: 'green'
    } );

    $( '.media-list-annotations .media' ).each( function( ) {
      var $this = $( this );
      var bbox = $this.data( 'bbox' );
      annotationsService.geomap( 'append', {
        type: 'Feature',
        geometry: $.geo.polygonize( bbox ),
        properties: {
          id: $this.attr( 'id' )
        }
      } );
    } );

    $( '#annotations-show' ).click( function( ) {
      showAnnotations = $( this ).is( ':checked' );
      annotationsService.geomap( 'toggle', showAnnotations );
      $( '.annotations-popup' ).addClass( 'hidden' );
    } );
  }
} );
