$( function( ) {
  if ( $( '.vis-controls' ).length ) {
    var props = $( '#props' );

    var vals = decodeURIComponent(window.location.search.replace("?","")).split("&");
    var propsHtml = '';

    var kv, v;

    for (var i = 0; i < vals.length; i++) {
      kv = vals[i].split("=");
      if (kv[0]=='include[]') {
        v = kv[1].split(":");
        propsHtml += "<span class='include'><a>x</a><input name='include[]' value='"+kv[1]+"' class='checkbox_hack'> "+v[1]+"</span> ";
      }
      else if (kv[0]=='exclude[]') {
        v=kv[1].split(":");
        propsHtml += "<span class='exclude'><a>x</a><input name='exclude[]' value='"+kv[1]+"' class='checkbox_hack'> "+v[1]+"</span> ";
      }
    }

    props.html( propsHtml );

    $( '.add-prop' ).click( function() {
      var sel = $( '#selprop' ).val();
      var val = $( '#propval' ).val();

      var className = $( this ).data( 'cmd' );
      var value = sel+":"+val;

      props.append( "<span class='"+className+"'><a>x</a><input class='checkbox_hack' name='"+className+"[]' value='"+value+"'> "+val+"</span> " );
    } );

    props.on( 'click', 'a', function() {
      $( this ).parent().remove();
    } );
  }
} );
