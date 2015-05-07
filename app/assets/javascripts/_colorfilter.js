$( function( ) { 
	var i,j;

	var x = document.getElementsByClassName("color-info");
	var y = document.getElementsByClassName("color-percent");

		for(i = 0, j = 0; (j < y.length) && (i < x.length); i++, j++){
			x[i].style.backgroundColor = x[i].innerHTML;
			x[i].style.width = y[j].innerHTML+"px";
			}
});