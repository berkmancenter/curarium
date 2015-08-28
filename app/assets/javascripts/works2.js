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
      }, {
        type: 'shingled',
        src: '',
        id: 'annotations-popup'
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

              //var position = map.geomap( 'toPixel', geo.coordinates );
              annotationsPopup.geomap( 'empty', false ).geomap( 'append', geo, popupHtml );
            } else {
              annotationsPopup.geomap( 'empty' );
            }
          }, 334 );
        }
      },

      shape: function( e, geo ) {
        console.log( geo.coordinates );
        map.geomap( 'option', 'mode', 'pan' );
        $( '.btn-drag-annotation' ).button( 'toggle' );

        //
        // 1. scale thumbnail to 150 in longest dimension
        // 2. draw thumbnail onto canvas
        // 3. save canvas dataURL to thumbnailUrl
        //

        // a kludge until I fix bbox in image service events
        var width = Math.abs( geo.bbox[2] - geo.bbox[0] );
        var height = Math.abs( geo.bbox[3] - geo.bbox[1] );

        // populate hidden form fields
        $( '#annotation_x' ).val( geo.bbox[0] );
        $( '#annotation_y' ).val( geo.bbox[1] - height );
        $( '#annotation_width' ).val( width );
        $( '#annotation_height' ).val( height );

        $( '#annotation_preview canvas' )[0].getContext( '2d' ).drawImage( img, geo.bbox[0], geo.bbox[1] - height, width, height, 0, 0, width, height );
        //$("#annotation_image_url").val(image_url)
        
        //var thumbnailUrl = 
        /*
          #create a second kinetic stage for previewing your annotation
          preview = new Kinetic.Stage(
            container: 'preview_window'
            width: if clipping.width > clipping.height then 180 else clipping.width * 180 / clipping.height
            height: if clipping.width > clipping.height then clipping.height * 180 / clipping.width else 180
          )
          preview_layer = new Kinetic.Layer()
          preview_image = new Kinetic.Image(
            image: surrogate
            crop: clipping
            scale:
              x: preview.getAttr('width')/surrogate.width
              y: preview.getAttr('height')/surrogate.height
          )
          preview_layer.add(preview_image)
          preview.add(preview_layer)
          crop.destroy()

          $("#content_thumbnail_url").val( $( '#preview_window canvas' )[0].toDataURL() )

          if ( !$( '.expand_anno' ).is( ':visible' ) )
            $( 'label[for="ann_id"]' ).click()
    undefined


    */

      }
      
    } );

    var annotationsService = $( '#annotations-service' );
    var annotationsPopup = $( '#annotations-popup' );

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

    $( '.btn-drag-annotation' ).click( function( ) {
      map.geomap( 'option', 'mode', 'dragBox' );
    } );

    $( '#annotations-show' ).click( function( ) {
      showAnnotations = $( this ).is( ':checked' );
      annotationsService.geomap( 'toggle', showAnnotations );
      annotationsPopup.geomap( 'empty' );
    } );
  }
} );
