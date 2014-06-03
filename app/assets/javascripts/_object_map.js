$( function() {
  var objectmap = $( '.records-objectmap' );
  if ( objectmap.length === 1 ) {
    var recordIds = objectmap.data( 'recordIds' );

    if ( $.isArray( recordIds ) && recordIds.length > 0 ) {
      $.geo.proj = null;
      var canvas = $( '<canvas width="256" height="256" />' );
      var context = canvas[0].getContext( '2d' );

      $( '.records-objectmap .geomap' ).geomap( {
        bbox: [ 0, 0, 1024, 768 ],
        zoom: 8,

        zoomMin: 8,
        zoomMax: 8,

        axisLayout: 'image',

        services: [
          {
            type: 'tiled',
            src: function( view ) {
              if ( view.tile.column >= 0 && view.tile.row >= 0 ) {
                var quadKey = tileToQuadkey( view.tile.column, view.tile.row, view.zoom );
                var index = tileToIndex( view.tile.column, view.tile.row, view.zoom );

                if ( index >= 0 && index < recordIds.length ) {
                  var defer = new jQuery.Deferred();
                  var img = new Image();

                  img.onload = function( ) {
                    context.clearRect( 0, 0, 256, 256 );
                    context.drawImage( img, 0, 0 );

                    defer.resolve( context.canvas.toDataURL( 'image/png' ) );
                  }

                  img.src = '/records/' + recordIds[index] + '/thumb';
                  return defer;
                } else {
                  return '';
                }
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
        }
      } );
    }
  }

  function tileToQuadkey( column, row, zoom ) {
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
