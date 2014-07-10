$( function( ) {
  if ( $( '.vis-controls' ).length ) {
    
    function escapeSpecialChars ( str ) {
      var from = ['<','>','\'','"'];
      var to = ['&lt;','&gt;','&#39;','&quot;'];
      for (var i = 0; i < from.length; i++) {
        str = str.replace( from[i], to[i] );
      }
      return str;
    }

    function propHtml( className, value, text ) {
      className = escapeSpecialChars( className );
      value = escapeSpecialChars( value );
      text = escapeSpecialChars ( text );
      return '<span class="' + className + '"><a href="#">x</a> <input class="checkbox_hack" name="' + className + '[]" value="' + value + '">' + text + '</span>';
    }

      

    var props = $( '#props' );

    var vals = decodeURIComponent(window.location.search.replace("?","")).split("&");
    var propsHtml = '';

    var kv, v;

    for (var i = 0; i < vals.length; i++) {
      kv = vals[i].split("=");
      v = kv[1].split(":");

      if (kv[0]=='include[]') {
        propsHtml += propHtml( 'include', kv[1], v[1] );
      } else if (kv[0]=='exclude[]') {
        propsHtml += propHtml( 'exclude', kv[1], v[1] );
      }
    }

    props.html( propsHtml );

    $( '#per_page' ).change( function() {
      $( '#vis-form' ).submit();
    } );


    $( '#vis' ).change ( function() {
      if ($.inArray(this.value,['thumbnails','list'])>-1) {
        $( '.page_in' ).prop('disabled',false);
      }
      else {
        $( '.page_in' ).prop('disabled',true);
      }
    } );

    $( '#vis' ).trigger('change')

    $( '.add-prop' ).click( function() {
      var sel = $( '#selprop' ).val();
      var val = $( '#propval' ).val();

      var className = $( this ).data( 'cmd' );
      var value = sel+":"+val;

      props.append( propHtml( className, value, val ) );
    } );

    props.on( 'click', 'a', function() {
      $( this ).parent().remove();
      return false;
    } );

  }
} );
