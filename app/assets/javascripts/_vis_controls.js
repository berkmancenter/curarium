( function ( $, undefined ) {
  var _defaults = {
  };

  var _options = { };

  function escapeSpecialChars ( str ) {
    var from = ['<','>','\'','"','+'];
    var to = ['&lt;','&gt;','&#39;','&quot;',' '];
    for (var i = 0; i < from.length; i++) {
      str = str.replace( new RegExp('\\' + from[i], 'g'), to[i] );
    }
    return str;
  }

  $.visControls = {
    init: function( options ) {
      _options = $.extend( { }, _defaults, options );

      var props = $( '#props' );

      var search = window.location.search.replace("?","");
      if ( search.length ) {
        var vals = decodeURIComponent(search).split("&");
        var propsHtml = '';

        var kv, v;

        for (var i = 0; i < vals.length; i++) {
          kv = vals[i].split("=");
          v = kv[1].split(":");

          if (kv[0]=='include[]') {
            propsHtml += $.visControls.propHtml( 'include', kv[1], v[0], v[1] );
          } else if (kv[0]=='exclude[]') {
            propsHtml += $.visControls.propHtml( 'exclude', kv[1], v[0], v[1] );
          } else if (kv[0]=='property') {
            $( '#property' ).val( v[0] );
          }
        }

        props.html( propsHtml );
      }

      $( '#toggle-vis-controls' ).click( function( ) {
        $( '.panel-vis-controls' ).toggleClass( 'hidden' );
        return false;
      } );

      $( document ).on( 'keyup', function( e ) {
        if ( ( e.type === 'keyup' && e.keyCode === 27 ) ) {
          $( '.panel-vis-controls' ).toggleClass( 'hidden', true );
        }
      } );

      $( '#usecolorfilter' ).click( function() {
        var enabled = $( this ).is( ':checked' );
        $( '#colorfilter' ).prop( 'disabled', !enabled ).parent( '.form-group' ).toggleClass( 'hidden', !enabled );
      } );

      $( '#per_page' ).change( function() {
        $( '#vis-form' ).submit();
      } );


      $( '#vis' ).change ( function() {
        if ($.inArray(this.value,['treemap'])>-1) {
          $( '#property' ).prop('disabled',false);
        }
        else {
          $( '#property' ).prop('disabled',true);
        }

        if ($.inArray(this.value,['thumbnails','list','colorfilter'])>-1) {
          $( '.page_in' ).prop('disabled',false);
        }
        else {
          $( '.page_in' ).prop('disabled',true);
        }
      } );

      $( '#vis' ).trigger('change')

      $( '#property' ).change( function() {
        $( '#selprop' ).val( $( this ).val( ) );
      } );

      $( '.add-prop' ).click( function() {
        var sel = $( '#selprop' ).val();
        var val = $( '#propval' ).val();

        if (val!=='') {
          var className = $( this ).data( 'cmd' );
          var value = sel+":"+val;
          props.append( $.visControls.propHtml( className, value, sel, val ) );
          $( '#propval' ).val('');
        }
      } );

      props.on( 'click', '.close', function() {
        $( this ).parent().remove();
        return false;
      } );
    },

    propHtml: function( className, value, propName, text ) {
      className = escapeSpecialChars( className );
      alertType = className === 'exclude' ? 'danger' : 'success';
      value = escapeSpecialChars( value );
      text = escapeSpecialChars( text );
      return '<div class="alert alert-' + alertType + '"> <button type="button" class="close">&times;</button><input type="hidden" name="' + className + '[]" value="' + value + '">' + "<b>" + propName + "</b>: " + text + '</div>';
    }
  };

  if ( $( '.vis-controls' ).length ) {
    $.visControls.init();
  }
} ) ( window.jQuery );

