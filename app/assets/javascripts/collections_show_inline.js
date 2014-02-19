$( function(){
  if ( $( '#collection_pages' ).length ) {
    window.collection.show();

    $('input#filter').val('');

    $('select').prop('selectedIndex', 0);

    $('#visualization_type').change(function(e){
      e.preventDefault();
      window.collection.query.type = $(this).val();
    });

    $('#visualization_property').change(function(e){
      e.preventDefault();
      window.collection.query.property = $(this).val();
    });

    $('#generate_visualization').submit(function(e){
      e.preventDefault();

      if($('#visualization_mode').val()===null || $('#visualization_property').val()===null){
        alert('please select visualization mode and property')
      } else {
        window.collection.generate_visualization();				
      }

    });

    $('#filter').keyup(function(e){
      var compare = $(this).val().toLowerCase();
      var l = compare.length;
      if(l>1){
        $('#property_list .property_list li').each(function(e) {
          if( $(this).data('value').toLowerCase().indexOf(compare) > -1 ){
            $(this).show();
          } else {
            $(this).hide();
          }
        });				
      }

    });
  }
} );

