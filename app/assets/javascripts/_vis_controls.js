$( function( ) {
  var props = $( '#props' );

  if ( props.length ) {
    var vals = decodeURIComponent(window.location.search.replace("?","")).split("&");
    var propsHtml = '';

    var i, kv, v, id;

    for (i=0, l=vals.length;i<l;i++) {
      kv = vals[i].split("=");
      if (kv[0]=='include[]') {
        id = kv[1].replace(/\s/g,'_');
        v = kv[1].split(":");
        propsHtml += "<span id='"+id+"' class='include'><a>x</a><input name='include[]' value='"+kv[1]+"' class='checkbox_hack'> "+v[1]+"</span> ";
      }
      else if (kv[0]=='exclude[]') {
        id=kv[1].replace(/\s/g,'_');
        v=kv[1].split(":");
        propsHtml += "<span id='"+id+"' class='exclude'><a>x</a><input name='exclude[]' value='"+kv[1]+"' class='checkbox_hack'> "+v[1]+"</span> ";
      }
    }

    props.html( propsHtml );
  }

  $( '.add-prop' ).click( function() {
    var sel = $( '#selprop' ).val();
    var val = $( '#propval' ).val();

    var className = $( this ).data( 'cmd' );
    var value = sel+":"+val;
    var id=val.replace(/\s/g,'_');

    props.append( "<span id='"+id+"' class='"+className+"'><a>x</a><input class='checkbox_hack' name='"+className+"[]' value='"+value+"'> "+val+"</span> " );
  } );

  props.on( 'click', 'a', function() {
    $( this ).parent().remove();
  } );

} );
