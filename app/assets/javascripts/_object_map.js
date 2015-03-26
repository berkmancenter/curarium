$( function() {
  var objectmap = $( '.works-objectmap' );

  if ( objectmap.length === 1 ) {
    var workIds = objectmap.data( 'workIds' );
    var paintedIndexes = [];
    var workDimension = Math.ceil( Math.sqrt( workIds.length ) );
    var timeoutMove = null;

    if ( $.isArray( workIds ) && workIds.length > 0 ) {
      $.geo.proj = null;

      var bigCanvas = $( '<canvas width="' + (256*workDimension) + '" height="' + (256*workDimension) + '" />' );
      var bigContext = bigCanvas[0].getContext( '2d' );

      var viewCanvas = $( '<canvas width="256" height="256" />' );
      var viewContext = viewCanvas[0].getContext( '2d' );

      var maxZoomLevels = 9;

      var map = $( '.works-objectmap .geomap' ).geomap( {
        center: [ Math.floor( 256 * workDimension / 2 ), Math.floor( 256 * workDimension / 2 ) ],
        zoom: 7,

        axisLayout: 'image',

        zoomMin: 5,

        services: [
          {
            type: 'shingled',
            src: function( view ) {
              var thumbBox = $.map( view.bbox, function( el ) {
                return el > 0 ? Math.min( Math.floor( el / 256 ), workDimension ) : 0;
              } );

              var tileDefer = new jQuery.Deferred();
              var imageDeferreds = [];
              var workIdIndex;

              for ( var row = thumbBox[1]; row < thumbBox[3]; row++ ) {
                for ( var col = thumbBox[0]; col < thumbBox[2]; col++ ) {
                  workIdIndex = row * workDimension + col;

                  if ( workIdIndex < workIds.length && paintedIndexes[ workIdIndex ] === undefined ) {
                    var imageDefer = new jQuery.Deferred();
                    imageDeferreds.push( imageDefer );

                    var img = new Image();
                    $( img ).data( { row: row, col: col, defer: imageDefer, workIdIndex: workIdIndex } );

                    img.onload = function( ) {
                      var $this = $( this );
                      bigContext.drawImage( this, $this.data( 'row' ) * 256, $this.data( 'col' ) * 256, 256, 256 );

                      paintedIndexes[ $this.data( 'workIdIndex' ) ] = true;


                      //miniContext.drawImage( img, xMini, yMini, miniSize, miniSize );
                      //miniMap.geomap( 'refresh' );

                      $this.data( 'defer' ).resolve();
                    };

                    img.onerror = function( ) {
                      $( this ).data( 'defer' ).resolve();
                    };

                    img.src = '/works/' + workIds[ workIdIndex ] + '/thumb';
                  }
                }
              }

              $.when.apply($, imageDeferreds ).then( function( ) {
                viewContext.canvas.width = view.width;
                viewContext.canvas.height = view.height;

                var zoom = map.geomap('option', 'zoom');
                var factor = Math.pow( 2, maxZoomLevels - zoom - 1 );

                var scale = 256 * workDimension / factor;

                var drawX = -view.bbox[ 0 ] / factor;
                var drawY = -view.bbox[ 1 ] / factor;

                viewContext.drawImage( bigCanvas[0], drawX, drawY, scale, scale );

                tileDefer.resolve( viewCanvas[0].toDataURL( 'image/png' ) );
              } );

              return tileDefer;
            }
          }, {
            id: 'highlight',
            type: 'shingled',
            src: ''
          }
        ],

        tilingScheme: {
          tileWidth: 256,
          tileHeight: 256,
          levels: 9,
          basePixelSize: 256,
          origin: [ 0, 0 ]
        },

        bboxchange: function( e, geo ) {
          updateMiniBbox( geo.bbox );
        },

        move: function( e, geo ) {
          if ( timeoutMove ) {
            clearTimeout( timeoutMove );
            timeoutMove = null;
          }

          timeoutMove = setTimeout( geomapMove( geo ), 32 );

        },

        click: function( e, geo ) {
          if ( geo.coordinates[ 0 ] >= 0 && geo.coordinates[ 1 ] >= 0 && geo.coordinates[ 0 ] < bigCanvas[0].width && geo.coordinates[ 1 ] < bigCanvas[0].height ) {
            var zoom = map.geomap( 'option', 'zoom' );
            var factor = Math.pow( 2, maxZoomLevels - zoom - 1 );
            var imageSize = 256 / factor;

            var tileXY = [ Math.floor( geo.coordinates[ 0 ] / 256 ), Math.floor( geo.coordinates[ 1 ] / 256 ) ];

            var index = tileXY[0] * workDimension + tileXY[1];

            if ( index < workIds.length ) {
              $.get( '/works/' + workIds[ index ], function( popupHtml ) {
                $.magnificPopup.open( {
                  showCloseBtn: false,
                  items: {
                    src: popupHtml,
                    type: 'inline'
                  }
                } );
              } );
            }
          }
        }
      } );

      var highlight = $( '#highlight' );


      function geomapMove( geo ) {
        if ( geo.coordinates[ 0 ] >= 0 && geo.coordinates[ 1 ] >= 0 && geo.coordinates[ 0 ] < bigCanvas[0].width && geo.coordinates[ 1 ] < bigCanvas[0].height ) {
          // TODO: cache factor somewhere, it only changes when zoom changes
          var zoom = map.geomap( 'option', 'zoom' );
          var factor = Math.pow( 2, maxZoomLevels - zoom - 1 );
          var imageSize = 256 / factor;

          var tileXY = [ Math.floor( geo.coordinates[ 0 ] / 256 ), Math.floor( geo.coordinates[ 1 ] / 256 ) ];

          highlight.geomap( 'empty', false );

          var pixelBbox = [ tileXY[ 0 ] * 256, tileXY[ 1 ] * 256, tileXY[ 0 ] * 256 + 256, tileXY[ 1 ] * 256 + 256 ];

          highlight.geomap( 'append', $.geo.polygonize( pixelBbox ) );
        } else {
          highlight.geomap( 'empty' );
        }
      }

      var miniCanvas = $( '<canvas width="256" height="256" />' );
      var miniContext = miniCanvas[0].getContext( '2d' );

      var miniDimension = Math.ceil( workDimension / 2 ) * 2;
      var miniScale = 1 / miniDimension;
      var miniSize = 256 * miniScale;

      // start with some random colors
      for ( var row = 0; row < miniDimension; row++ ) {
        for ( var col = 0; col < miniDimension; col ++ ) {            
          miniContext.fillStyle = '#'+randRed();
          miniContext.fillRect( miniSize * col, miniSize * row, miniSize, miniSize );
        }
      }

      var miniMap = $( '.works-objectmap .minimap' ).geomap( {
        bbox: [ 0, 0, 256, 256 ],
        bboxMax: [ 0, 0, 256, 256 ],

        mode: 'static',

        services: [
          {
            type: 'shingled',
            src: function( view ) {
              return miniContext.canvas.toDataURL( 'image/png' );
            },
            style: {
              opacity: .98
            }
          }
        ],

        tilingScheme: null,

        shapeStyle: {
          color: '#dedede'
        }
      } );

      miniMap.click( function( e ) {
        map.geomap( 'option', 'center', [ e.offsetX / miniSize * 256, e.offsetY / miniSize * 256 ] );
        updateMiniBbox();
      } );

      updateMiniBbox();
    }
  }

  function updateMiniBbox( bbox ) {
    bbox = bbox || map.geomap( 'option', 'bbox' );

    var miniBbox = [
      Math.min( Math.max( bbox[0] * miniScale, 0 ), 256 ),
      256 - Math.min( Math.max( bbox[1] * miniScale, 0 ), 256 ),
      Math.min( Math.max( bbox[2] * miniScale, 0 ), 256 ),
      256 - Math.min( Math.max( bbox[3] * miniScale, 0 ), 256 )
    ]; 
    miniMap.geomap( 'empty' ).geomap( 'append', $.geo.polygonize( miniBbox ) );
  }

  function IntRand (min,max) {
    return Math.round(Math.random()*(max-min)+min);
  }

  function randRed () {
    var r = IntRand(0xaa,0xff);
    var g = IntRand(0x00,0x55);
    var b = IntRand(0x00,0x55);
    return ((r<<16)|(g<<8)|b).toString(16);
  }

} );
