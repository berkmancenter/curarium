vals = decodeURIComponent(window.location.search.replace("?","")).split("&");
var props;
window.onload = function () {
  props = document.getElementById('props');
  
  for (i=0,l=vals.length;i<l;i++) {
    kv = vals[i].split("=");
    if (kv[0]=='include[]') {
      id=kv[1].replace(/\s/g,'_');
      v=kv[1].split(":");
      props.innerHTML += "<span id='"+id+"' class='include'><a onClick='removeEl(\""+id+"\")'>x</a><input name='include[]' value='"+kv[1]+"' class='checkbox_hack'> "+v[1]+"</span> ";
    }
    else if (kv[0]=='exclude[]') {
      id=kv[1].replace(/\s/g,'_');
      v=kv[1].split(":");
      props.innerHTML += "<span id='"+id+"' class='exclude'><a onClick='removeEl(\""+id+"\")'>x</a><input name='exclude[]' value='"+kv[1]+"' class='checkbox_hack'> "+v[1]+"</span> ";
    }
  }
}

function addprop(include) {
  sel = document.getElementById('selprop').value;
  val = document.getElementById('propval').value;
  className = include?'include':'exclude';
  value = sel+":"+val;
  id=val.replace(/\s/g,'_');
  props.innerHTML += "<span id='"+id+"' class='"+className+"'><a onClick='removeEl(\""+id+"\")'>x</a><input class='checkbox_hack' name='"+className+"[]' value='"+value+"'> "+val+"</span> ";
}

function removeEl(id) {
  el = document.getElementById(id);
  if (el!=null) {
    el.parentNode.removeChild(el);
  }
}

