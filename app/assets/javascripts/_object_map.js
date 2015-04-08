$( function() {
  var objectmap = $( '.works-objectmap' );
  var baseThumbSize = 128;

  if ( objectmap.length === 1 ) {
    var workIds = objectmap.data( 'workIds' );
    var paintedIndexes = [];
    var workDimension = Math.ceil( Math.sqrt( workIds.length ) );
    var timeoutMove = null;

    if ( $.isArray( workIds ) && workIds.length > 0 ) {
      $.geo.proj = null;

      var bigCanvas = $( '<canvas width="' + (baseThumbSize * workDimension) + '" height="' + (baseThumbSize * workDimension) + '" />' );
      var bigContext = bigCanvas[0].getContext( '2d' );

      var viewCanvas = $( '<canvas width="128" height="128" />' );
      var viewContext = viewCanvas[0].getContext( '2d' );

      var maxZoomLevels = 9;

      var center = [ Math.floor( baseThumbSize * workDimension / 2 ), Math.floor( baseThumbSize * workDimension / 2 ) ];
      var mapWidth = $( '.works-objectmap .geomap' ).width();

      var map = $( '.works-objectmap .geomap' ).geomap( {
        bbox: [ 0, center[ 1 ] - baseThumbSize, baseThumbSize * workDimension, center[ 1 ] + baseThumbSize ],

        mode: 'click',
        cursors: {
          click: 'pointer'
        },


        axisLayout: 'image',

        zoomMax: 8,
        zoomMin: 2,

        services: [
          {
            type: 'shingled',
            style: {
              opacity: 0.99
            },
            src: function( view ) {
              var zoom = $( '.geomap' ).geomap('option', 'zoom');
              var factor = Math.pow( 2, maxZoomLevels - zoom - 1 );
              var imageSize = baseThumbSize / factor;

              //console.log( 'view.bbox: ' + view.bbox );

              var thumbBox = [
                Math.max( ( Math.floor( view.bbox[0] / baseThumbSize ) - 1), 0),
                Math.max( ( Math.floor( view.bbox[1] / baseThumbSize ) - 1), 0),
                Math.min( ( Math.ceil( view.bbox[2] / baseThumbSize ) ) + 1, workDimension),
                Math.min( ( Math.ceil( view.bbox[3] / baseThumbSize ) ) + 1, workDimension)
              ];

              //console.log( 'thumbBox: ' + thumbBox );

              var tileDefer = new jQuery.Deferred();
              var imageDeferreds = [];
              var workIdIndex;

              for ( var y = thumbBox[1]; y < thumbBox[3]; y++ ) {
                for ( var x = thumbBox[0]; x < thumbBox[2]; x++ ) {
                  workIdIndex = y * workDimension + x;

                  if ( workIdIndex < workIds.length && paintedIndexes[ workIdIndex ] === undefined ) {
                    //console.log( 'REQUEST x: ' + x + ', y: ' + y + ', index: ' + workIdIndex + ', workId: ' + workIds[ workIdIndex ] );

                    var imageDefer = new jQuery.Deferred();
                    imageDeferreds.push( imageDefer );

                    var img = new Image();
                    $( img ).data( { x: x, y: y, defer: imageDefer, workIdIndex: workIdIndex } );

                    img.onload = function( ) {
                      var $this = $( this );
                      bigContext.drawImage( this, 0, 0, this.width, this.height, $this.data( 'x' ) * baseThumbSize, $this.data( 'y' ) * baseThumbSize, baseThumbSize * (this.width/256), baseThumbSize * (this.height/256));

                     //console.log( 'PAINT x: ' + $this.data( 'x' ) + ', y: ' + $this.data( 'y' ) + ', index: ' + $this.data( 'workIdIndex' ) + ', workId: ' + workIds[ $this.data( 'workIdIndex' ) ] );

                      paintedIndexes[ $this.data( 'workIdIndex' ) ] = true;


                      //miniContext.drawImage( img, xMini, yMini, miniSize, miniSize );
                      //miniMap.geomap( 'refresh' );

                      $this.data( 'defer' ).resolve();
                    };

                    img.onerror = function( ) {
                      $( this ).data( 'defer' ).resolve();
                    };

                    img.src = '/thumbnails/works/' + workIds[ workIdIndex ] + '.jpg';
                  }
                }
              }

              $.when.apply($, imageDeferreds ).then( function( ) {
                viewContext.canvas.width = view.width;
                viewContext.canvas.height = view.height;

                var scale = baseThumbSize * workDimension / factor;

                var drawX = -view.bbox[ 0 ] / factor;
                var drawY = -view.bbox[ 1 ] / factor;

                //console.log( bigCanvas[0].toDataURL( 'image/png' ) );
                viewContext.drawImage( bigCanvas[0], 0, 0, baseThumbSize * workDimension, baseThumbSize * workDimension, drawX, drawY, scale, scale );

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
          // disable for now, it slows down the map
          return false;

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
            var imageSize = baseThumbSize / factor;

            var tileXY = [ Math.floor( geo.coordinates[ 0 ] / baseThumbSize ), Math.floor( geo.coordinates[ 1 ] / baseThumbSize ) ];

            var index = tileXY[1] * workDimension + tileXY[0];

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
          var imageSize = baseThumbSize / factor;

          var tileXY = [ Math.floor( geo.coordinates[ 0 ] / baseThumbSize ), Math.floor( geo.coordinates[ 1 ] / baseThumbSize ) ];

          highlight.geomap( 'empty', false );

          var pixelBbox = [ tileXY[ 0 ] * baseThumbSize, tileXY[ 1 ] * baseThumbSize, tileXY[ 0 ] * baseThumbSize + baseThumbSize, tileXY[ 1 ] * baseThumbSize + baseThumbSize ];

          highlight.geomap( 'append', $.geo.polygonize( pixelBbox ) );
        } else {
          highlight.geomap( 'empty' );
        }
      }

      var miniCanvas = $( '<canvas width="128" height="128" />' );
      var miniContext = miniCanvas[0].getContext( '2d' );

      var miniScale = 1 / workDimension;
      var miniSize = baseThumbSize * miniScale;

      // start with some random colors
      for ( var row = 0; row < workDimension; row++ ) {
        for ( var col = 0; col < workDimension; col ++ ) {            
          miniContext.fillStyle = '#'+randRed();
          miniContext.fillRect( miniSize * col, miniSize * row, miniSize, miniSize );
        }
      }

      var miniMap = $( '.works-objectmap .minimap' ).geomap( {
        bbox: [ 0, 0, baseThumbSize, baseThumbSize ],
        bboxMax: [ 0, 0, baseThumbSize, baseThumbSize ],

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
        map.geomap( 'option', 'center', [ e.offsetX / miniSize * baseThumbSize, e.offsetY / miniSize * baseThumbSize ] );
        updateMiniBbox();
      } );

      updateMiniBbox();
    }
  }

  function updateMiniBbox( bbox ) {
    bbox = bbox || map.geomap( 'option', 'bbox' );

    var miniBbox = [
      Math.min( Math.max( bbox[0] * miniScale, 0 ), baseThumbSize ),
      baseThumbSize - Math.min( Math.max( bbox[1] * miniScale, 0 ), baseThumbSize ),
      Math.min( Math.max( bbox[2] * miniScale, 0 ), baseThumbSize ),
      baseThumbSize - Math.min( Math.max( bbox[3] * miniScale, 0 ), baseThumbSize )
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
