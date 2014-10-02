$( function() {
  var container = '.records-treemap';
  var treemapContainer = $( container );

  var click, selected, tree;
  var selected = [];

  var visProperty = $( '#property' ).val();

  if ( treemapContainer.length === 1 ) {
    var propertyCounts = treemapContainer.data( 'propertyCounts' );

    if ( $.isArray( propertyCounts ) && propertyCounts.length > 0 ) {
      tree( {
        children: propertyCounts
      } );
    }
  }

  function tree( root ) {
    var color, div, height, margin, max_value, n, node, position, treemap, width, _fn, _i, _len, _ref;
    d3.selectAll(container + ' *').remove();
    max_value = 0;
    _ref = root.children;
    _fn = function(n) {
      if (max_value < n.id) {
        return max_value = n.id;
      }
    };
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      n = _ref[_i];
      _fn(n);
    }
    margin = {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    };
    width = $(container).width() - margin.left - margin.right;
    height = $(container).height() - margin.top - margin.bottom;
    color = d3.scale.linear().domain([0, max_value / 8, max_value / 4, max_value / 2, max_value]).range(['#c83737', '#ff9955', '#5aa02c', '#2a7fff']);
    treemap = d3.layout.treemap().size([width, height]).value(function(d) {
      if (selected.indexOf(d.parsed) < 0) {
        return d.id;
      } else {
        return null;
      }
    });
    div = d3.select(container).style('overflow', 'hidden').append("div").attr('id', 'chart-container').style("position", "relative").style("width", (width + margin.left + margin.right) + "px").style("height", (height + margin.top + margin.bottom) + "px").style("left", margin.left + "px").style("top", margin.top + "px");
    position = function() {
      this.style("left", function(d) {
        return d.x + "px";
      }).style("top", function(d) {
        return d.y + "px";
      }).style("width", function(d) {
        return Math.max(0, d.dx - 1) + "px";
      }).style("height", function(d) {
        return Math.max(0, d.dy - 1) + "px";
      });
    };
    node = div.datum(root).selectAll(".node").data(treemap.nodes).enter().append("a").attr("href", "#").attr("class", "node").call(position).style("background", function(d) {
      if (d.id != null) {
        return color(d.id);
      }
    }).text( function(d) {
      if (d.parsed !== void 0) {
        return d.parsed + '(' + d.id + ')';
      } else {
        return '';
      }
    } ).on('click', function(e) {
      var val = d3.select(this).data()[0].parsed;

      if (val !== '') {
        var className = 'include';
        var value = visProperty+":"+val;
        $( '#props' ).append( $.visControls.propHtml( className, value, val ) );
        $( '#propval' ).val('');
      }

      $( '#vis-form' ).submit();
      return false;
    } );
  }
} );
