$( function( ) { 
  // TODO: Note, this can all be handled server-side
  var i, j, k;

  var x = document.getElementsByClassName("color-info");
  var y = document.getElementsByClassName("color-percent");
  var z = document.getElementsByClassName("color-hex");

  for(i = 0, j = 0, k=0; (j < y.length) && (i < x.length) && (k < z.length); i++, j++, k++){
    x[i].style.backgroundColor = x[i].innerHTML;
    x[i].style.color = x[i].innerHTML;
    x[i].style.width = (y[j].innerHTML)+"%";
    x[i].title = z[k].innerHTML;
  }
});
