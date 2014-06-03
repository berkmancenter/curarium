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
              var defer = new jQuery.Deferred();
              var img = new Image();

              img.onload = function( ) {
                context.drawImage( img, 0, 0 );

                defer.resolve( context.canvas.toDataURL( 'image/png' ) );
              }

              img.src = '/records/1/thumb';
              return defer;
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
} );
