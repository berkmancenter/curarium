$( function() {
  var objectmap = $( '.records-objectmap' );
  if ( objectmap.length === 1 ) {
    var recordIds = objectmap.data( 'recordIds' );

    if ( $.isArray( recordIds ) && recordIds.length > 0 ) {
      $.geo.proj = null;

      $( '.records-objectmap .geomap' ).geomap( {
        bbox: [ 0, 0, 1024, 768 ],
        zoom: 8,

        zoomMin: 7,
        zoomMax: 8,

        axisLayout: 'image',

        services: [
          {
            type: 'tiled',
            src: function( view ) {
              if ( view.tile.column >= 0 && view.tile.row >= 0 ) {
                // each tile needs a canvas now...I think,
                // since drawing may happen over multiple async calls
                var canvas = $( '<canvas width="256" height="256" />' );
                var context = canvas[0].getContext( '2d' );

                var quadKey = tileToQuadKey( view.tile.column, view.tile.row, view.zoom );

                var indexes = quadKeyToIndexes( quadKey );
                var imageSize = Math.pow( 2, view.zoom );
                var imageDepth = Math.ceil( indexes.length / 2 );
                //console.log( 'quadKey: ' + quadKey + ', indexes: ' + indexes.join(', ') );

                var tileDefer = new jQuery.Deferred();




                var imageDeferreds = [];

                $.each( indexes, function( tileImageIndex ) { 
                  var recordIdIndex = this;

                  var x = imageSize * ( ( tileImageIndex % 2 ) ); //imageDepth );
                  var y = imageSize * Math.floor( tileImageIndex / imageDepth );

                  var xMini = miniSize * ( ( tileImageIndex % 2 ) ); //imageDepth );
                  var yMini = miniSize * Math.floor( tileImageIndex / miniDimension );

                  if ( recordIdIndex >= 0 && recordIdIndex < recordIds.length ) {
                    //console.log( 'x: ' + x + ', y: ' + y );


                    var imageDefer = new jQuery.Deferred();
                    imageDeferreds.push( imageDefer );

                    var img = new Image();

                    //console.log( '  id: ' + recordIds[ recordIdIndex ] );
                    img.onload = function( ) {
                      //context.clearRect( 0, 0, 256, 256 );

                      context.drawImage( img, x, y, imageSize, imageSize );

                      //miniContext.drawImage( img, xMini, yMini, miniSize, miniSize );
                      //miniMap.geomap( 'refresh' );

                      imageDefer.resolve();
                    };

                    img.onerror = function( ) {
                      imageDefer.resolve();
                    };

                    img.src = '/records/' + recordIds[ recordIdIndex ] + '/thumb';

                  } else {
                    //context.fillStyle = '#ff0000';
                    context.fillRect( x, y, imageSize, imageSize );
                  }

                } );

                $.when.apply($, imageDeferreds ).then( function( ) {
                  tileDefer.resolve( context.canvas.toDataURL( 'image/png' ) );
                } );




                return tileDefer;
              } else {
                return '';
              }
            }
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
          console.log( 'bboxchange: ' + geo.bbox.join( ', ' ) );
          console.log( 'miniScale: ' + miniScale );
          console.log( 'bboxchange: ' + $.map( geo.bbox, function( v ) { return Math.min( Math.max( v * miniScale, 0 ), 256 ) } ).join( ', ' ) );
          var miniBbox = [
            Math.min( Math.max( geo.bbox[0] * miniScale, 0 ), 256 ),
            256 - Math.min( Math.max( geo.bbox[1] * miniScale, 0 ), 256 ),
            Math.min( Math.max( geo.bbox[2] * miniScale, 0 ), 256 ),
            256 - Math.min( Math.max( geo.bbox[3] * miniScale, 0 ), 256 )
          ]; 
          miniMap.geomap( 'empty' );
          miniMap.geomap( 'append', $.geo.polygonize( miniBbox ) );
        }
      } );

      var miniCanvas = $( '<canvas width="256" height="256" />' );
      var miniContext = miniCanvas[0].getContext( '2d' );

      var recordDimension = Math.ceil( Math.sqrt( recordIds.length ) );
      var miniDimension = Math.ceil( recordDimension / 2 ) * 2;
      var miniScale = 1 / miniDimension;
      var miniSize = 256 * miniScale;
      console.log( 'miniScale: ' + miniScale );
      console.log( 'miniSize: ' + miniSize );

      // start with some random colors
      for ( var row = 0; row < miniDimension; row++ ) {
        for ( var col = 0; col < miniDimension; col ++ ) {
          miniContext.fillStyle = '#'+Math.floor(Math.random()*16777215).toString(16);
          miniContext.fillRect( miniSize * col, miniSize * row, miniSize, miniSize );
        }
      }


      var miniMap = $( '.records-objectmap .minimap' ).geomap( {
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

        tilingScheme: null
      } );
    }
  }

  function tileToQuadKey( column, row, zoom ) {
    var quadKey = "",
        digit,
        mask;
    
    for ( var i = zoom; i > 0; i-- ) {
      digit = 0;
      mask = 1 << (i - 1);
      if ((column & mask) !== 0) {
        digit++;
      }
      if ((row & mask) !== 0) {
        digit += 2;
      }
      quadKey += digit;
    }
    return quadKey;
  }

  function quadKeyToIndexes( quadKey ) {
    if ( quadKey.length === 8 ) {
      var index = 0,
          digit;

      for ( var i = quadKey.length - 1; i > 0; i-- ) {
        digit = parseInt( quadKey[ i ] );
        index += Math.pow( 4, 8 - i) * digit / 4;
      }

      return [ index ];
    } else {
      var indexes = [];
      $.merge( indexes, quadKeyToIndexes( quadKey + '0' ) );
      $.merge( indexes, quadKeyToIndexes( quadKey + '1' ) );
      $.merge( indexes, quadKeyToIndexes( quadKey + '2' ) );
      $.merge( indexes, quadKeyToIndexes( quadKey + '3' ) );
      return indexes;
    }
  }

  function tileToIndex( column, row, zoom ) {
    var index = 0,
        digit,
        mask;
    
    for ( var i = zoom; i > 0; i-- ) {
      digit = 0;
      mask = 1 << (i - 1);
      if ((column & mask) !== 0) {
        digit++;
      }
      if ((row & mask) !== 0) {
        digit += 2;
      }
      index += Math.pow( 4, i) * digit / 4;
    }
    return index;
  }
} );
