//this code was provided by Ole Goethe, along with Spatial C
$.widget("ui.zoomify", {
  options: {image: "", zoom: 1, x: 0, y: 0, max: 400, ratio_hw: 0},
  image: {},
  loaded: false,
  viewport: {x: 0, y:0, zoom: 1, isCommand: false },

  updateDisplay: function() {    
    var self = this;
    var content = this.element;

    if( !self.loaded ) { return false; }

    var image = content.find(".display").get(0);
    self.image = image;
    
    var ratio_hw = image.width / image.height;
    content.find(".view").height(image.height + 2);

    if (isNaN(self.viewport.y)) 
      {
        self.viewport.y = $('.display').height() * self.options.y
      }
    if (isNaN(self.viewport.x)) {
      self.viewport.x = $('.display').width() * self.options.x
    }
    var frame = content.find(".frame");    
    frame.css({"top": self.viewport.y, "left": self.viewport.x});

    if (self.options.ratio_hw > 0)
    {
      var frame_w = image.width / self.viewport.zoom
      frame.width(frame_w)
      frame.height(frame_w * self.options.ratio_hw)
    } else {
      frame.width(image.width / self.viewport.zoom);
      frame.height(image.height / self.viewport.zoom);
    }
    
    

    var frameWidth = frame.css("border-bottom-width").replace(/\D/g, "");
    frameWidth *= 2;    

    if( frame.width() + self.viewport.x > image.width - frameWidth ) {
      self.viewport.x = image.width - frame.width() - frameWidth;
      frame.css("left", self.viewport.x);
    } else if ( self.viewport.x < 0 ) {
      self.viewport.x = 0
      frame.css('left', 0)
    }

    if( frame.height() + self.viewport.y > image.height - frameWidth ) {
      self.viewport.y = image.height - frame.height() - frameWidth;
      frame.css("top", self.viewport.y);
    } else if ( self.viewport.y < 0 ) {
      self.viewport.y = 0
      frame.css('top', 0)
    }
    
    var isCommand = false
    if (self.viewport.isCommand)
    {
      isCommand = true
      self.viewport.isCommand = false
    }
    self._trigger("update", null, {
      x: self.viewport.x / image.width,
      y: self.viewport.y / image.height,
      zoom: self.viewport.zoom,
      isCommand: isCommand
    }); 
  },
  
  _create: function() {
    var self = this;
    var options = this.options;
    var element = this.element;
    element.addClass("ui-zoomify");

    self.viewport = {zoom: options.zoom, x: options.x, y: options.y};
    
    var content = $('<div class="window"><div class="view"><div class="frame"></div><img class="display" src="'+options.image+'"></div></div><div class="settings"><input type="text" value=""><div class="slider"></div></div>').appendTo(element);
    content.find("input").attr("value", self.viewport.zoom * 100 + "%");
    content.find(".display").load(function() { self.loaded = true; self.updateDisplay(); }).bind('dragstart', function(event) { event.preventDefault(); });;

    content.find(".frame").draggable({
      containment: "parent",
      drag: function(event, ui) {
       self.viewport.x = ui.position.left;
       self.viewport.y = ui.position.top;
       self.viewport.isCommand = true
       self.updateDisplay();
     }
   });
    
    content.find(".slider").slider({
      min: 100,
      max: this.options.max,
      value: self.viewport.zoom * 100,
      slide: function(event, ui) {
        $(this).parent().find("input").attr("value", ui.value + "%");
        self.viewport.zoom = content.find("input").attr("value").replace(/\%/g, "") / 100;
        self.viewport.isCommand = true
        self.updateDisplay();
      }
    });

    content.find("input").keypress(function(e) {
      if(e.which == 13){
        var input = $(this);
        var value =  input.attr("value");
        
        // Set the slider's value
        $("#control .slider").slider("option", "value", value.replace(/\%/g, ""));

        // Add percent sign back in
        input.attr("value", value.replace(/\%/g, "") + "%");
        self.viewport.zoom = content.find("input").attr("value").replace(/\%/g, "") / 100;
        
        self.updateDisplay();
      }
    });

    $(window).resize(function() { self.updateDisplay(); });
  },

  _setOption: function(option, value) {
    var self = this;
    
    $.Widget.prototype._setOption.apply( this, arguments );

    switch(option) {
      case "image":
      this.element.find("#display").attr("src", value);
      break;
      case "zoom":
      self.viewport.zoom = value;
      self.element.find(".slider").slider("option", "value", value * 100);
      self.element.find("input").attr("value", (value * 100) + "%");
      break;
      case "x":
      self.viewport.x = value * self.image.width
      break;
      case "y":
      self.viewport.y = value * self.image.height
      break;
    }
  },

  _init: function() {
    this.updateDisplay();
  }
});
