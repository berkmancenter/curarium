/*
 * SpatialM - jQuery script for styling large object maps
 *  
 * Copyright (c) 2013-2014 Ole Goethe
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Revision: 107 2014-04-25
 */

/*

 	This are the line numbers where chunks of code HAD to be commented out in order for spatial C to work decoupled from story assembler, websocket, admin panels, etc. 
 	273,358,397,640,768,1648
 	
 	the "init" functions begin in line 1694. The first one had to be commented and a line added to is so it jumps straight to "init_step_4()"
 	
 	In both cases (commented blocks and init function), the problem might be solved by adding some conditional clauses. 
 	
 	To correct a bug that was preventing some collections from loading, a "try... catch" statement was added in line 628.
 	This is probably a patch solution that again could be solved by adding conditionals.
 	There is also an issue with zooming in for smaller collections which I still haven't been able to figure out.
 	
 	Finally, in lines 273 and 300 the onclick behavior of each block was modified so instead of opening a pop-up, it opens the record page in a new tab.
 	This was not a 'bug' but rather a necessary modification to integrate with our code.
 	
*/
 	 



(function( $ ){


    function Socket(address)
    {
        this.init(address)
    }

    Socket.prototype.init = function(address)
    {
        if (this.ws) ws.close()
        if (!address)
        {
            this.ws = new WebSocket("ws://localhost:8888/websocket")
        } else {
            this.ws = new WebSocket(address)
        }
        this.ws.onopen = this.onopen
        this.ws.onmessage = this.onmessage
    }

    Socket.prototype.onmessage = function(evt)
    {
        alert(evt.data)
    }

    Socket.prototype.onopen = function()
    {
        
    }

    Socket.prototype.send = function(buf)
    {
        var ws = this.ws
        this.waitForSocketConnection(ws, function(){
            console.log("message sent!!!")
            ws.send(buf)
        })
    }

    Socket.prototype.waitForSocketConnection = function(socket, callback){
        setTimeout(
            function () {
                if (socket.readyState === 1) {
                    console.log("Connection is made")
                    if(callback != null){
                        callback();
                    }
                    return;
                } else {
                    console.log("wait for connection...")
                    settings.ws.waitForSocketConnection(socket, callback);
                }
        }, 5)
    }


    function FlashBlock(opt)
    {
        this.settings = {
            side_size: 10,
            x: 0,
            y: 0,
            container: null,
            zIndex: 1000,
            opacity_start: 1,
            opacity_end: 0.1,
            duration: 500,
            color: '#fff'
        }
        this.init(opt)
        return this
    }

    FlashBlock.prototype.reinit = function(opt)
    {
        this.init(opt)
    }

    FlashBlock.prototype.isPlaced = function()
    {
        if (this.flashbang.parentElement != null)
        {
            return true
        }
        return false
    }

    FlashBlock.prototype.init = function(opt)
    {
        $.extend(this.settings, opt)

        if (!this.flashbang)
        {
            this.flashbang = document.createElement('div')
        }
        
        this.flashbang.style.height = this.settings.side_size + 'px'
        this.flashbang.style.width = this.settings.side_size + 'px'
        this.flashbang.style.zIndex = this.settings.zIndex
        this.flashbang.style.opacity = this.settings.opacity_start
        this.flashbang.style.position = 'absolute'
        this.flashbang.style.backgroundColor = this.settings.color
        this.flashbang.style.left = this.settings.x
        this.flashbang.style.top = this.settings.y

        if (this.flashbang.parentElement)
        {
            this.flashbang.parentElement.removeChild(this.flashbang)
        }
    }

    FlashBlock.prototype.placeAndWait = function()
    {
        this.flashbang.style.opacity = this.settings.opacity_start
        this.settings.container.appendChild(this.flashbang)
        return this
    }

    FlashBlock.prototype.removeFromDom = function()
    {
        this.settings.container.removeChild(this.flashbang)
    }

    FlashBlock.prototype.bang = function()
    {
        var self = this
        if (!this.isPlaced())
        {
            this.placeAndWait()
        }
        $(this.flashbang).animate({'opacity': this.settings.opacity_end }, 
                                    this.settings.duration,
                                    function() { 
                                        this.parentElement.removeChild(this) 
                                    }
                                )
    }

    function ImagesLoader()
    {
        this.init()
    }

    ImagesLoader.prototype.init = function()
    {
        this.block_queue = new Array()
        this.urgent_block_queue = new Array()
        this.urgent_image_queue = new Array()
        this.block_queue_pointer = 0
        this.urgent_image_queue_pointer = 0
        this.urgent_block_queue_pointer = 0
        this.is_locked = false
        this.is_processing = false
    }

    ImagesLoader.prototype.queueBlock = function(block)
    {
        if ( (this.block_queue.indexOf(block) == -1) )
        {
            this.block_queue.push(block)
        }
    }

    ImagesLoader.prototype.queueUrgentBlock = function(block)
    {
            this.urgent_block_queue.push(block)
    }

    ImagesLoader.prototype.queueUrgentImage = function(url)
    {
            this.urgent_image_queue.push(url)
    }

    ImagesLoader.prototype.loadQueue = function()
    {
        this.processImagesQueue()
        this.processImagesQueue()
    }

    ImagesLoader.prototype.processImagesQueue = function()
    {
        this.is_processing = true
        while(this.is_locked){}; this.is_locked = true

        if (this.urgent_image_queue.length > this.urgent_image_queue_pointer) 
        {
            var i = this.urgent_image_queue_pointer
            this.urgent_image_queue_pointer++
            var img = new Image;
            img.src = this.urgent_image_queue[i]
            img.onload = function() {
                this.remove()
                settings.images_loader.processImagesQueue()
            }
        } else if (this.urgent_block_queue.length > this.urgent_block_queue_pointer) {
            var i = this.urgent_block_queue_pointer
            this.urgent_block_queue_pointer++
            var block = this.urgent_block_queue[i]
            var img = new Image;
            img.src = block.info['thumbnail']
            img.element = block.element
            img.onload = this.removeClassFromParent
        } else if (this.block_queue.length > this.block_queue_pointer) {
            var i = this.block_queue_pointer
            this.block_queue_pointer++
            var block = this.block_queue[i]
            var img = new Image;
            img.src = block.info['thumbnail']
            img.element = block.element
            img.onload = this.removeClassFromParent
        } else {
            this.is_processing = false
        }
        this.is_locked = false
    }

    ImagesLoader.prototype.removeClassFromParent = function()
    {
        this.element.block.loaded()
        $(this).remove()
        this.element.block.is_rendered = true
        settings.images_loader.processImagesQueue()
    }

    ImagesLoader.prototype.reset = function()
    {
        while(this.is_locked){}; this.is_locked = true
        this.init()
    }

    function Block(id, serial, thumbnail, title, cid, parsed)
    {
        this.info = {
            'id': id,
            'title': title,
            'serial': serial,
            'cid': cid,
            'parsed':parsed
        }

        if (thumbnail.indexOf('?') == -1)
        {
            $.extend(this.info, {
            'thumbnail': thumbnail + '?width=' + Math.ceil(settings.side_size * 2) + 
                                    '&height=' + Math.ceil(settings.side_size * 2),
            'fullsize': thumbnail + '?height=' + Math.ceil(parseInt(document.body.clientHeight) * 0.6) + 
                                    '&width=' + Math.ceil(parseInt(document.body.clientWidth) * 0.6 * 0.45)
            })
        } else {
            $.extend(this.info, {
            'thumbnail': thumbnail,
            'fullsize': thumbnail})
        }
        
        this.is_rendered = false

        this.element = document.createElement('div')
        this.element.setAttribute('class', 'item loading')
        this.element.setAttribute('id', id)
        this.element.style.backgroundImage = 'url(' + this.info['thumbnail'] + ')'
        //this.element.onclick = this.openSpotlight
        this.element.onmouseup = this.movemouseup
        this.element.block = this
		
		
        var moveicon = document.createElement('div')
        moveicon.setAttribute('class', 'moveicon')
        moveicon.onmousedown = this.movemousedown
        moveicon.pressed = false
        moveicon.style.display = 'none'
        this.element.appendChild(moveicon)

        var text = document.createElement('span')
        text.setAttribute('class', 'text')
        text.innerHTML = id
        this.element.appendChild(text)

        this.ghost_block = null
    }

    Block.prototype.loaded = function()
    {
        $(this.element).removeClass('loading')
        $(this.element).find('.moveicon').css('display', 'block')
        var id = this.element.getAttribute('id')
        this.element.onclick = function(){
			window.open('http://curarium.herokuapp.com/records/' + id, '_blank');
		};
        for (prop in this.clones)
        {
            var clone = this.clones[prop]
            $(clone).removeClass('loading')
            $(clone).find('.moveicon').css('display', 'block')
        }
    }

    Block.prototype.getElement = function()
    {
        return this.element
    }
    
    Block.prototype.openSpotlight = function(e)
    {
        if (this.getAttribute('class').indexOf('item') > -1) {
            settings.shade_div.style.display = 'block'
            settings.display_block.title.innerHTML = 'Title: ' + this.block.info['title']
            settings.display_block.image.setAttribute('src', '/assets/ajax.gif')
            settings.display_block.image.setAttribute('src', this.block.info['fullsize'])
            settings.images_loader.queueUrgentImage(this.block.info['fullsize'])
            settings.images_loader.loadQueue()
            // settings.display_block.author.innerHTML = 'Author: ' + block.author
            // settings.display_block.subjects.innerHTML = 'Subjects: ' + block.subjects
            // settings.display_block.topics.innerHTML = 'Topics: ' + block.topics
        }
    }
    
    Block.prototype.movemousedown = function(e)
    {
        settings.drag_block = this.parentElement
        if (settings.drag_block.parentElement == settings.blocks_panel.blocks_panel)
        {
            var block = settings.drag_block.block
            var serial = block.info['serial']
            var y = Math.floor(serial / settings.blocks_panel.total_columns)
            var x = serial % settings.blocks_panel.total_columns
            settings.blocks_panel.placePlug(block, x, y)
        }
        settings.drag_block.pressed = true
        document.body.appendChild(settings.drag_block)
        document.body.onmousemove = Block.prototype.movemousemove
        Block.prototype.movePx(settings.drag_block, e.pageX, e.pageY)
        $('body').addClass('unselectable')
        this.parentElement.style.height = settings.side_size * 0.8 + 'px'
        this.parentElement.style.width = settings.side_size * 0.8 + 'px'
    }

    Block.prototype.movemouseup = function(e)
    {
        document.body.onmousemove = null
        
        if (!settings.drag_block || !settings.drag_block.pressed) return
        this.pressed = false
        $('body').removeClass('unselectable')
        var id = settings.drag_block.block.info['id']
        var block = settings.block_hub.getBlockById(id)
        /*for (var i = 0, il = settings.userpanel_hub.count(); i < il; i++)  //THIS BLOCK HAS TO BE KEPT COMMENTED
        {
            var userpanel = settings.userpanel_hub.getUserPanel(i)
            if (userpanel.checkIfHovered(e.pageX, e.pageY))
            {
                block.element.style.display = 'none'
                var panel = settings.userpanel_hub.isAnyUserPanelHasId(id)
                if (panel == userpanel) panel = null
                
                userpanel.dropBlock(block, e.pageX, e.pageY)

                if (panel) 
                {
                    panel.removeBlock(id)
                }
                highlightEmptyPlugs(-1000, -1000)
                return
            }
        }*/
        returnBlockBack(block)
    }

    Block.prototype.movemousemove = function(e)
    {
        Block.prototype.movePx(settings.drag_block, e.pageX, e.pageY)
        highlightEmptyPlugs(e.pageX, e.pageY)
    }

    Block.prototype.movePx = function(elem, x, y)
    {
        $(elem).css({
            'top': y - settings.side_size * 0.8 / 2,
            'left': x - settings.side_size * 0.8 / 2,
        })
    }


    function highlightEmptyPlugs(x, y)
    {
        /*for (var i = 0, il = settings.userpanel_hub.count(); i < il; i++) //THIS BLOCK HAS TO BE KEPT COMMENTED
        {
            var up = settings.userpanel_hub.getUserPanel(i)
            for (var k = 0, kl = up.plugs.length; k < kl; k++)
            {
                var plug = up.plugs[k]
                var plug_rect = plug.getBoundingClientRect()
                if ( ( plug_rect.left < x ) && 
                     ( (plug_rect.left + plug_rect.width) > x) &&
                     ( plug_rect.top < y  ) &&
                     ( plug_rect.top + plug_rect.height > y  ) )
                {
                    if (!plug.style.backgroundColor)
                    {
                        plug.style.backgroundColor = '#ddd'
                        $(plug).animate({backgroundColor: '#fff'}, 250)
                    }
                } else {
                    plug.style.backgroundColor = ''
                }

            }
        }*/
    }




    function BlockHub()
    {
        this.url = 'anyurl'
        //this.blocks_array = new Array()
	
		this.blocks_array = new Array()
        this.wasSorted = false
        this.sort_by = 'title'
        this.sort_direction = 'asc'
    }
    
    BlockHub.prototype.sortBy = function(field)
    {
        function compare_asc(a,b) {
	    var first = a.info.parsed[field] || [null];
	    var second = b.info.parsed[field] || [null];
            if (first[0] < second[0])
                return -1
            if (first[0] > second[0])
                return 1
            return 0
        }

        function compare_desc(a,b) {
            var first = a.info.parsed[field] || [null];
	    var second = b.info.parsed[field] || [null];
            if (first[0] > second[0])
                return -1
            if (first[0] < second[0])
                return 1
            return 0
        }
        this.sort_by = field

        if (this.sort_direction == 'asc')
        {
            this.blocks_array.sort(compare_asc)
        } else {
            this.blocks_array.sort(compare_desc)
        }

        // asign new serial values
        for (var i = 0, il = this.blocks_array.length; i < il; i++)
        {
            var block = this.blocks_array[i]
            block.info['prev_serial'] = block.info['serial']
            block.info['serial'] = i
        }

        this.wasSorted = true
    }

    BlockHub.prototype.sortDirection = function(sort_direction)
    {
        this.sort_direction = sort_direction
        this.sortBy(this.sort_by)
    }
    

    BlockHub.prototype.addBlock = function(block) {
        this.blocks_array.push(block)
    }

    BlockHub.prototype.getBlockBySerial = function(index) {
        return this.blocks_array[index]
    }

    BlockHub.prototype.getBlockById = function(id) {
        for (var i = 0, il = this.blocks_array.length; i < il; i++)
        {
            if (this.blocks_array[i].info['id'] == id) return this.blocks_array[i]
        }
        return null
    }

    BlockHub.prototype.excludeBlock = function(id) {
        for (var i = 0, il = this.blocks_array.length; i < il; i++)
        {
            var block = this.blocks_array[i]
            if (block.info['id'] == id) 
            {
                this.blocks_array.splice(i, 1)
                return block
            }
        }
        return null
    }

    BlockHub.prototype.clearHub = function(element) {
        this.blocks_array = new Array()
    }

    BlockHub.prototype.count = function(element) {
        return this.blocks_array.length
    }




    function Panel(container, opt)
    {
        var self = this
        if (!container) return
        this.super_container = container
        this.side_size = opt.side_size
        this.current_point = {'x': 0, 'y': 0}
        
        this.container = document.createElement('div')
        this.info_panel = document.createElement('div')
        this.blocks_panel = document.createElement('div')
        this.nav_left = document.createElement('div')
        this.nav_right = document.createElement('div')

        this.info_panel.setAttribute('class', 'info-panel')
        this.container.style.height = Math.floor(opt.height) + 'px'
        this.nav_right.onclick = function() { self.movePanel(3, 0) }
        this.nav_left.onclick = function() { self.movePanel(-3, 0) }
        this.nav_left.setAttribute('class', 'nav-buttons vertical left')
        this.nav_right.setAttribute('class', 'nav-buttons vertical right')
        var div_text = document.createElement('div')
        div_text.setAttribute('class', 'text')
        div_text.innerHTML = 'right'
        this.nav_right.appendChild(div_text)
        var div_text2 = div_text.cloneNode(false)
        div_text2.innerHTML = 'left'
        this.nav_left.appendChild(div_text2)

        this.blocks_panel.style.top = '0px'
        this.blocks_panel.style.left = '0px'

        this.super_container.appendChild(this.info_panel)
        this.super_container.appendChild(this.container)
        this.container.appendChild(this.blocks_panel)
        this.container.appendChild(this.nav_left)
        this.container.appendChild(this.nav_right)

        this.updateViewportSizes()
    }
    
    Panel.prototype.updateViewportSizes = function()
    {
        var c_rect = this.container.getBoundingClientRect()
        this.viewport = {
            'center_x': c_rect.left + c_rect.width / 2, 
            'center_y': c_rect.top + c_rect.height / 2,
            'width': c_rect.width,
            'height': c_rect.height,
        }
    }

    Panel.prototype.placeElement = function(elem, x, y)
    {
        elem.style.left = x * this.side_size + 'px'
        elem.style.top = y * this.side_size + 'px'
        elem.style.height = this.side_size + 'px'
        elem.style.width = this.side_size + 'px'
        this.blocks_panel.appendChild(elem)
    }

    function BlocksPanel(container, opt)
    {
        Panel.call(this, container, opt)
        var self = this

        this.wasMoved = true
        this.nav_up = document.createElement('div')
        this.nav_down = document.createElement('div')
        this.nav_up.onclick = function() { self.movePanel(0, -3) }
        this.nav_down.onclick = function() { self.movePanel(0, 3) }
        this.nav_up.setAttribute('class', 'nav-buttons horizontal up')
        this.nav_down.setAttribute('class', 'nav-buttons horizontal down')
        var div_text = document.createElement('div')
        div_text.setAttribute('class', 'text')
        div_text.innerHTML = 'up'
        this.nav_up.appendChild(div_text)
        var div_text2 = div_text.cloneNode(false)
        div_text2.innerHTML = 'down'
        this.nav_down.appendChild(div_text2)

        this.container.appendChild(this.nav_up)
        this.container.appendChild(this.nav_down)
        this.container.setAttribute('class', 'blocks-panel-container')
        this.blocks_panel.setAttribute('class', 'blocks-panel')

        this.scale = 1
        this.scale_min = 0.4
        this.scale_max = 4

        this.addOnWheelEventListener()
    }

    BlocksPanel.prototype = new Panel()
    BlocksPanel.prototype.constructor = BlocksPanel
    BlocksPanel.prototype.setBlockHub = function(block_hub) 
    { 
        this.block_hub = block_hub
        this.total_columns = Math.floor(Math.sqrt(this.block_hub.count()))
        this.total_rows = Math.ceil(this.block_hub.count() / this.total_columns)
        var w = this.total_columns * this.side_size
        var h = this.total_rows * this.side_size
        this.blocks_panel.style.width = w + 'px'
        this.blocks_panel.style.height = h + 'px'
        this.current_point.x = w / 2
        this.current_point.y = h / 2
        this.calibrateZoomtoscale()
        this.createMinimap()
        this.scale_min = this.zoomtoScale(1)
    }
    
    BlocksPanel.prototype.update = function()
    {
        if (!this.block_hub) return
        
        // places blocks panel
        if (this.wasMoved)
        {
            this.wasMoved = false
        
            var bp_rect = this.blocks_panel.getBoundingClientRect()
            var current_x = this.current_point.x * this.scale
            var current_y = this.current_point.y * this.scale

            var bp_x = bp_rect.left + current_x
            var bp_y = bp_rect.top + current_y

            var deltax = bp_x - this.viewport.center_x
            var deltay = bp_y - this.viewport.center_y 

            this.blocks_panel.style.left = parseInt(this.blocks_panel.style.left) - deltax + 'px'
            this.blocks_panel.style.top = parseInt(this.blocks_panel.style.top) - deltay + 'px'
        }

        // calculating visible ranges
        var real_side_size = this.side_size * this.scale
        var x_left = this.current_point.x - this.viewport.width / this.scale / 2
        var x_right = this.current_point.x + this.viewport.width / this.scale / 2
        var y_top = this.current_point.y - this.viewport.height / this.scale / 2
        var y_bottom = this.current_point.y + this.viewport.height / this.scale / 2

        var column_left = Math.floor(x_left / this.side_size)
        var column_right = Math.ceil(x_right / this.side_size)
        var row_top = Math.floor(y_top / this.side_size)
        var row_bottom = Math.ceil(y_bottom / this.side_size)

        if (column_left < 0) column_left = 0
        if (column_right >= this.total_columns) column_right = this.total_columns
        if (row_top < 0) row_top = 0
        if (row_bottom >= this.total_rows) row_bottom = this.total_rows

        this.visible_serials = new Array()

        for (var y = row_top; y < row_bottom; y++)  // places visible objects on blocks_panel
        {
            var row_serial = y * this.total_columns
            for (var x = column_left; x < column_right; x++)
            {
            	try { //THIS CODE WAS FAILING FOR SMALLER IMAGE SETS, SO I PUT IT INSIDE A TRY-CATCH STATEMENT. THIS IS A TEMPORARY SOLUTION. -P
            		
            	var serial = row_serial + x
                this.visible_serials.push(serial)
                var block = this.block_hub.getBlockBySerial(serial)
                var id = block.info['id']
            
                if (block.is_rendered == false)
                {
                    settings.images_loader.queueBlock(block)
                }                
                var elem = null
                /*if (settings.userpanel_hub.isAnyUserPanelHasId(id)) //THIS BLOCK HAS TO BE KEPT COMMENTED
                {
                    this.placePlug(block, x, y)
                    block.element.style.display = 'none'
                    if (block.ghost_block)
                    {
                        if (block.ghost_block.isPlaced())
                        {
                            block.ghost_block.bang()
                        }
                    }
                } else {*/
                    elem = block.getElement()
                    elem.style.display = 'block'
                    this.placeElement(elem, x, y)
                    if (settings.ghost_mode) 
                    {
                        this.ghostIt(block)
                    }
                //}
                } catch(e) {
            		console.log(e);
            	}
            }
        }
        settings.images_loader.loadQueue()

        $(this.blocks_panel).find('.item').each(function(){   /// removes invisible objects from DOM
            var serial = this.block.info['serial']
            if (settings.blocks_panel.visible_serials.indexOf(parseInt(serial)) == -1)
            {
                var block = settings.block_hub.getBlockBySerial(serial)
                if (block.element.parentElement == settings.blocks_panel.blocks_panel) 
                {
                    settings.blocks_panel.blocks_panel.removeChild(block.getElement())
                }
                block.is_rendered = false
                if (block.ghost_block)
                {
                    block.ghost_block.removeFromDom()
                    block.ghost_block = null
                }
            }
        })
       
        var zoom = this.getCurrentZoom()
        var x = (this.current_point.x - this.viewport.width / this.scale / 2) / parseInt(this.blocks_panel.style.width) 
        var y = (this.current_point.y - this.viewport.height / this.scale / 2) / parseInt(this.blocks_panel.style.height)
        
        $('#minimap').zoomify({
            x: x, 
            y: y, 
            zoom: zoom
        })
    }

    BlocksPanel.prototype.ghostIt = function(block)
    {
        if (!block.ghost_block)
        {
            var flash = this.flashBlock(block, {
                color: '#010',
                opacity_start: 0.7,
                duration: 200,
            })
            flash.placeAndWait()
            block.ghost_block = flash
        } else {
            block.ghost_block.placeAndWait()
        }
    }

    BlocksPanel.prototype.ghostOff = function()
    {
        for (var i = 0, il = this.visible_serials.length; i < il; i++)
        {
            var block = this.block_hub.getBlockBySerial(this.visible_serials[i])
            if (block.ghost_block)
            {
                block.ghost_block.bang()
                block.ghost_block = null
            }
            
        }
    }
    
    BlocksPanel.prototype.changeViewportHeight = function(height)
    {
        var self = this
        // this.container.style.height = Math.floor(height) + 'px'
        $(this.container).animate({ 'height': Math.floor(height) + 'px'}, 100, function(){
            self.updateViewportSizes()
            self.wasMoved = true
            self.update()
        })
        
    }

    BlocksPanel.prototype.placePlug = function(block, x, y)
    {
        if (!block.plug)
        {
            var row_serial = y * this.total_columns
            var serial = row_serial + x + 1

            var elem = document.createElement('div')
            elem.setAttribute('class', 'plug')
            var a = document.createElement('div')
            a.innerHTML = serial
            elem.appendChild(a)
            this.placeElement(elem, x, y)

            elem.onclick = this.plugClick
            block.plug = elem
        }
    }

    BlocksPanel.prototype.plugClick = function()
    {
        var block = settings.block_hub.getBlockBySerial($(this).find('div').html() - 1 )
        returnBlockBack(block)
    }

    function returnBlockBack(block)
    {
        var elem = block.getElement()
        var id = block.info['id']

        /*var userpanel = settings.userpanel_hub.isAnyUserPanelHasId(id) //THIS BLOCK HAS TO BE KEPT COMMENTED
        if (userpanel)
        {
            userpanel.removeBlock(id)
            userpanel.update()
        }*/

        if (settings.blocks_panel.blocks_panel != elem.parentElement)
        {
            settings.blocks_panel.blocks_panel.appendChild(elem)
            settings.blocks_panel.update()
        }
        elem.style.display = 'block'
        
        if (block.plug) 
        {
            block.plug.remove()
            block.plug = null
        }

        settings.blocks_panel.flashBlock(block, {'color': '#f00'}).bang()
        
        highlightEmptyPlugs(-1000, -1000)
    }

    BlocksPanel.prototype.flashBlock = function(block, opt)
    {
        var def_opt = {
            container: settings.blocks_panel.blocks_panel,
            zIndex: 20,
            side_size: settings.side_size,
            color: '#f00',
            x: block.getElement().style.left,
            y: block.getElement().style.top,
        }
        $.extend(def_opt, opt)
        return new FlashBlock(def_opt)
    }

    BlocksPanel.prototype.createMinimap = function()
    {
        var self = this
        var max_zoom = this.scaletozoom(this.scale_max)
        var zoom = this.scaletozoom(this.scale)
        $('#minimap').zoomify({
            zoom: this.scaletozoom(this.scale),
            image: 'img/minimap_bg.png',
            max: max_zoom * 100,
            ratio_hw: this.container.getBoundingClientRect().height / this.container.getBoundingClientRect().width,
            update: function(e, ui){
                if (ui.isCommand)
                {
                    self.takePosFromMinimap(ui)
                    self.applyScale(self)
                }
            }
        })
        $('#map-toggle').click(function(){
            if($('#minimap').css('visibility') == 'hidden') 
                $('#minimap').css('visibility', 'visible') 
            else 
                $('#minimap').css('visibility', 'hidden') 
        })
        $('#minimap').find('.closesign').click(function(){ $('#minimap').css('visibility', 'hidden') })
    }

    BlocksPanel.prototype.movePanel = function(deltax, deltay)
    {
	
        this.current_point.x += deltax * this.side_size, this.current_point.y += deltay * this.side_size
        this.wasMoved = true
        render()
    }

    BlocksPanel.prototype.scaletozoom = function(scale)
    {
        return scale * this.zoomscale_ratio
    }

    BlocksPanel.prototype.zoomtoScale = function(zoom)
    {
        return zoom / this.zoomscale_ratio
    }

    BlocksPanel.prototype.getCurrentZoom = function()
    {
        var b_w = this.container.getBoundingClientRect().width
        var bp_w = this.blocks_panel.getBoundingClientRect().width

        return bp_w / b_w
    }

    BlocksPanel.prototype.takePosFromMinimap = function(ui)
    {
        
	this.scale = this.zoomtoScale(ui.zoom)

        this.current_point.x = ui.x * parseInt(this.blocks_panel.style.width) + this.viewport.width / this.scale / 2
        this.current_point.y = ui.y * parseInt(this.blocks_panel.style.height) + this.viewport.height / this.scale / 2
    }

    BlocksPanel.prototype.calibrateZoomtoscale = function()
    {
        var b_w = this.container.getBoundingClientRect().width
        var bp_w = this.blocks_panel.getBoundingClientRect().width
        var zoom = bp_w / b_w
        this.zoomscale_ratio = zoom / this.scale
    }

    BlocksPanel.prototype.zoomOut = function(self)
    {
        self.scale = self.scale - 0.1
        if (self.scale < self.scale_min) 
        {
            self.scale = self.scale_min
            return false
        }
        self.applyScale(self)
    }

    BlocksPanel.prototype.zoomIn = function(self)
    {
        self.scale = self.scale + 0.1
        if (self.scale > self.scale_max)
        {
            self.scale = self.scale_max
        }
        self.applyScale(self)
    }

    BlocksPanel.prototype.onWheel = function(e) 
    {
        e = e || window.event
        var delta = e.deltaY || e.detail || e.wheelDelta
        if (delta < 0)
        {
            this.selfe.zoomIn(this.selfe)
        } else {
            this.selfe.zoomOut(this.selfe)
        }
    }


    BlocksPanel.prototype.addOnWheelEventListener = function()
    {
        this.blocks_panel.selfe = this
        if (this.blocks_panel.addEventListener) {
            if ('onwheel' in document) {
                this.blocks_panel.addEventListener ("wheel", this.onWheel, false);
            } else if ('onmousewheel' in document) {
                this.blocks_panel.addEventListener ("mousewheel", this.onWheel, false);
            } else {
                this.blocks_panel.addEventListener ("MozMousePixelScroll", this.onWheel, false);
            }
        } else { 
            this.blocks_panel.attachEvent ("onmousewheel", this.onWheel);
        }
    }

    BlocksPanel.prototype.applyScale = function(self)
    {
        $(this.blocks_panel).css({
            '-webkit-transform': 'scale(' + this.scale + ')',
            '-ms-transform': 'scale(' + this.scale + ')',
            'transform': 'scale(' + this.scale + ')',
        })
        this.wasMoved = true
        render()
    }

    
    
    
    function UserPanelHub()
    {
        this.userpanel_array = new Array()
    }
    
    UserPanelHub.prototype.showHiddenPanelIfAvail = function()
    {
        for (var i = 0, il = this.userpanel_array.length; i < il; i++)
        {
            var userpanel = this.userpanel_array[i]
            if (userpanel.isHidden())
            {
                userpanel.show()
                return true
            }
        }
        return false
    }

    UserPanelHub.prototype.addUserPanel = function()
    {
        var userpanel = null
        if (!this.showHiddenPanelIfAvail())
        {
            if (this.userpanel_array.length < 4)
            {
                var userpanel = new UserPanel(settings.story_holder)
                this.userpanel_array.push(userpanel)
                this.setNewBlocksPanelHeight()
            } else {
                return null
            }
        }
        if (this.visiblePanelsCount() == 1)
        {
            $('.ss').css('display', 'block')
        }
        return userpanel
    }

    UserPanelHub.prototype.hideUserPanel = function(userpanel)
    {
        if (this.userpanel_array.length > 0)
        {
            for (var i = this.userpanel_array.length - 1, il = 0; i >= il; i--)
            {
                var userpanel = this.userpanel_array[i]
                if (!userpanel.isHidden())
                {
                    userpanel.hide()
                    if (this.visiblePanelsCount() == 0)
                    {
                        $('.ss').css('display', 'none')
                    }
                    return
                }
            }
        }
    }

    UserPanelHub.prototype.visiblePanelsCount = function()
    {
        var visible_userpanel_count = 0
        for (var i = 0, il = this.userpanel_array.length; i < il; i++)
        {
            var userpanel = this.userpanel_array[i]
            if (!userpanel.isHidden())
            {
                visible_userpanel_count++
            }
        }
        return visible_userpanel_count
    }

    UserPanelHub.prototype.setNewBlocksPanelHeight = function()
    {
        var visible_userpanel_count = this.visiblePanelsCount()

        var story_assembler_text_height = 28+5

        if ($('.ss').css('display') == 'none')
        {
            story_assembler_text_height = 0
        } else {
            story_assembler_text_height = 28+5
        }
        
        var newheight = settings.container.getBoundingClientRect().height - story_assembler_text_height - 
                         (visible_userpanel_count * (settings.side_size * 0.8 * 1.4)) - 
                        $('#footer')[0].clientHeight
        settings.blocks_panel.changeViewportHeight( newheight )
    }
    
    UserPanelHub.prototype.count = function(userpanel)
    {
        return this.userpanel_array.length
    }
    
    UserPanelHub.prototype.getUserPanel = function(index)
    {
        return this.userpanel_array[index]
    }

    UserPanelHub.prototype.loadUserPanels = function(callback)
    {
        var self = this
        $.ajax({
            type: 'POST',
            url: '/load-userpanels/',
            data: {
            },
            success: function(msg){
                msg = JSON.parse(msg)
                if (msg.length)
                {
                    $.extend(self.story_array, msg) 
                }
            },
            error: function(msg){
                self.story_array = new Array()
            },
            complete: function(){
                if (callback) callback()
            }
        })
    }

    UserPanelHub.prototype.saveUserPanels = function(callback)
    {
        var self = this
        $.ajax({
            type: 'POST',
            url: '/save-userpanels/',
            data: {
                'userpanels': JSON.stringify(this.userpanel_array)
            },
            success: function(msg){
                msg = JSON.parse(msg)
                if (msg.length)
                {
                    $.extend(self.story_array, msg) 
                }
            },
            error: function(msg){
                //showMessage('error: ' + msg['responseText'])
            },
            complete: function(){
                if (callback) callback()
            }
        })
    }

    UserPanelHub.prototype.isAnyUserPanelHasId = function(id)
    {
        for (var i = 0, il = settings.userpanel_hub.count(); i < il; i++)
        {
            var userpanel = settings.userpanel_hub.getUserPanel(i)
            if (userpanel.isHidden()) continue
            if (userpanel.hasId(id))
            {
                return userpanel
            }
        }
        return null
    }

    function UserPanel(container)
    {
        var opt = {
            'height': settings.side_size * 0.8, 
            'side_size': settings.side_size * 0.8, 
            'index': settings.userpanel_hub.count(),
            'plug_letter': String.fromCharCode(65 + settings.userpanel_hub.count()),
        }
        this.block_hub = new BlockHub()
        this.serial = settings.userpanel_hub.count() + 1

        Panel.call(this, container, opt)
        
        var self = this
        
        this.story = settings.story_hub.getStoryByIndex(opt.index)
        this.createStoryBlocks()

        this.plug_letter = opt.plug_letter
        
        this.container.setAttribute('class', 'user-panel-container')
        this.blocks_panel.setAttribute('class', 'user-panel')

        this.info_panel.style.height = Math.floor(opt.height * 0.4) + 'px'
        this.info_panel.innerHTML = 'Story text'

        this.plugs = new Array()
        this.hidden = false
    }
    UserPanel.prototype = new Panel()
    UserPanel.prototype.constructor = UserPanel

    UserPanel.prototype.createStoryBlocks = function()
    {
        var seq = this.story.info['sequencer']
        for (var i = 0, il = seq.length; i < il; i++)
        {
            var info = seq[i]
            var block = new Block(info['id'], info['serial'], info['thumbnail'], info['title'], info['cid'])
            this.block_hub.addBlock(block)
            var elem = block.getElement()
            elem.style.height = this.side_size + 'px'
            elem.style.width = this.side_size + 'px'
            this.blocks_panel.appendChild(elem)
            block.isNew = true
        }
    }

    UserPanel.prototype.isHidden = function()
    {
        return this.hidden
    }
    
    UserPanel.prototype.hide = function()
    {
        this.hidden = true
        this.super_container.removeChild(this.container)
        this.super_container.removeChild(this.info_panel)
        settings.userpanel_hub.setNewBlocksPanelHeight()
    }

    UserPanel.prototype.show = function()
    {
        this.hidden = false
        this.super_container.appendChild(this.info_panel)
        this.super_container.appendChild(this.container)
        settings.userpanel_hub.setNewBlocksPanelHeight()
        this.update()
    }


    UserPanel.prototype.checkIfHovered = function(x, y)
    {
        var up_rect = this.container.getBoundingClientRect()
        if (y > up_rect.top && y < (up_rect.top + up_rect.height))
        {
            return true
        } else {
            return false
        }
    }

    UserPanel.prototype.removeBlock = function(id)
    {
        i = this.findIndexOfBlockInSequencer(id)
        if (i > -1)
        {
            this.story.info['sequencer'].splice(i, 1)
            this.story.saveStory()

            var block = this.block_hub.excludeBlock(id)
            block.element.remove()
            block = null
            this.update()
        }
    }

    UserPanel.prototype.dropBlock = function(block, x, y)
    {
        var ubp_rect = this.blocks_panel.getBoundingClientRect()
        var place_x = x - ubp_rect.left
        var place_serial = Math.floor(place_x / this.side_size)
        this.addBlock($.extend({}, block.info), place_serial)
    }

    UserPanel.prototype.addBlock = function(info, serial)
    {
        var seq_elem = info
        if (serial) seq_elem['serial'] = serial
        var sb = this.getByPlace(seq_elem['serial'])
        var index = this.findIndexOfBlockInSequencer(seq_elem['id'])
        this.story.info['sequencer'].push(seq_elem)

        if (index == -1)
        {
            if (sb != null)
            {
                var place_serial = seq_elem['serial']
                while(true)
                {
                    place_serial++
                    if (this.getByPlace(place_serial) == null)
                    {
                        sb.serial = place_serial
                        break
                    }
                }
            }
        } else {
            if (sb != null)
            {
                sb.serial = this.story.info['sequencer'][index]['serial']
            }
        }
        var block = new Block(seq_elem['id'], seq_elem['serial'], seq_elem['thumbnail'], seq_elem['title'], seq_elem['cid'])
        this.block_hub.addBlock(block)
        var elem = block.getElement()
        elem.style.height = this.side_size + 'px'
        elem.style.width = this.side_size + 'px'
        this.blocks_panel.appendChild(elem)
        block.isNew = true
        settings.images_loader.queueUrgentBlock(block)
        this.update()
        this.story.saveStory()
    }

    UserPanel.prototype.serial2px = function(serial)
    {
        return serial * this.side_size
    }

    UserPanel.prototype.px2serial = function(px, width)
    {
        return Math.floor( px / this.side_size )
    }

    UserPanel.prototype.update = function()
    {
        if (this.hidden) return

        for (var i = 0, il = this.story.info['sequencer'].length; i < il; i++)
        {
            var sequencer = this.story.info['sequencer'][i]
            var block = this.block_hub.getBlockById(sequencer.id)
            settings.images_loader.queueBlock(block)
            var elem = block.getElement()
            elem.style.left = this.serial2px(sequencer.serial) + 'px'
            if (block.isNew)
            {
                new FlashBlock({
                    container: this.blocks_panel,
                    zIndex: 3,
                    side_size: this.side_size,
                    color: '#0f0',
                    x: elem.style.left,
                    y: 0
                }).bang()
                block.isNew = false
            }
        }
        settings.images_loader.loadQueue()
        var width = this.container.getBoundingClientRect().width
        var x = 0 - parseInt(this.blocks_panel.style.left)
        x -= x % this.side_size
        width += x
        while (x < width)
        {
            var serial = this.px2serial(x)
            if (!this.isPlugExists(serial))
            {
                var plug = document.createElement('div')
                plug.setAttribute('class', 'user-panel-plug')
                plug.setAttribute('data-serial', serial)
                var a = document.createElement('div')
                a.innerHTML = this.plug_letter + "" + (serial + 1)
                plug.appendChild(a)
                this.placeElement(plug, serial, 0)
                this.plugs.push(plug)
            }
            x += this.side_size
        }
        var self = this
        $(this.blocks_panel).find('.item').mouseenter( function() {
            var id = this.block.info['id']
            var block = settings.block_hub.getBlockById(id)
            if (block.plug)
            {
                $(block.plug).addClass('rotate')
                // window.setTimeout(function() {
                //     $(block.plug).removeClass('rotate')
                // }, 2000)
            }
        }).mouseleave( function() {
            var id = this.block.info['id']
            var block = settings.block_hub.getBlockById(id)
            if (block.plug)
            {
                $(block.plug).removeClass('rotate')
            }
        })
    }

    UserPanel.prototype.isPlugExists = function(serial)
    {
        for (var i = 0, il = this.plugs.length; i < il; i++)
        {
            var data_serial = parseInt(this.plugs[i].getAttribute('data-serial'))
            if (this.plugs[i].getAttribute('data-serial') == serial)
            {
                return true
            }
        }
        return false
    }

    UserPanel.prototype.findIndexOfBlockInSequencer = function(id)
    {
        for (var i = 0, il = this.story.info['sequencer'].length; i < il; i++)
        {
            if (this.story.info['sequencer'][i].id == id)
            {
                return i
            }
        }
        return -1
    }

    UserPanel.prototype.getByPlace = function (place)
    {
        for (var i = 0, il = this.story.info['sequencer'].length; i < il; i++)
        {
            if (this.story.info['sequencer'][i].serial == place)
            {
                return this.story.info['sequencer'][i]
            }
        }
        return null
    }

    UserPanel.prototype.hasId = function(id)
    {
        for (var i = 0, il = this.story.info['sequencer'].length; i < il; i++)
        {
            if ( (this.story.info['sequencer'][i].id == id) )
                return true
        }
        return false
    }

    UserPanel.prototype.movePanel = function(deltax, deltay)
    {
        this.blocks_panel.style.left = parseInt(this.blocks_panel.style.left) - deltax * settings.side_size + 'px'
        this.update()
    }

    function User()
    {
        this.reset()
    }

    User.prototype.reset = function()
    {
        this.user = {
            'uid': 0,
            'name': null,
            'email': null
        }
    }

    User.prototype.getId = function()
    {
        return this.user['uid']
    }

    User.prototype.loadsJson = function(jsondata)
    {
        $.extend(this.user, JSON.parse(jsondata))
    }

    User.prototype.logIn = function(username, passwd, callback)
    {
        var self = this
        $.ajax({
            type: 'POST',
            url: '/login/',
            data: {
                'username': username,
                'passwd': passwd
            },
            success: function(msg){
                msg = JSON.parse(msg)
                if (msg['result'] == 'successful')
                {
                    $.extend(self.user, msg['user']) 
                }
                if ($('.loginpanel').css('display') == 'block')
                {
                    $('.loginpanel').css('display', 'none')
                }
            },
            error: function(msg){
                alert(msg['responseText'])
            },
            complete: function(){
                settings.opt.login = null /// need for not to cycle with logging in
                settings.first = true     /// first run
                /// emulating new url to reload blocks
                if (!settings.opt.url)
                {
                    settings.opt.url = settings.url
                }
                settings.url = null
                if (callback) callback()
            }
        })
    } 

    User.prototype.createNewUser = function(callback)
    {
        var self = this
        $.ajax({
            type: 'POST',
            url: '/login/createnewuser/',
            data: {
            },
            success: function(msg){
                msg = JSON.parse(msg)
                if (msg['result'] == 'successful')
                {
                    $.extend(self.user, msg['user']) 
                }
            },
            error: function(msg){
                alert(msg['responseText'])
            },
            complete: function(){
                if (callback) callback()
            }
        })
    }

    User.prototype.getUserDetails = function(callback)
    {
        var self = this
        $.ajax({
            type: 'POST',
            url: '/get-user-details/',
            data: {
            },
            success: function(msg){
                msg = JSON.parse(msg)
                if (msg['result'] == 'successful')
                {
                    $.extend(self.user, msg['user']) 
                }
            },
            error: function(msg){
                alert(msg['responseText'])
            },
            complete: function(){
                if (callback) callback()
            }
        })
    }

    User.prototype.authenticate = function()
    {
        var user_cookie = getCookie('userid')
        if (!user_cookie)
        {
            this.createNewUser(init_step_2)
            return
        } else {
            this.getUserDetails(init_step_2)
            return
        }
        
        init_step_2()
    }

    function StoryHub()
    {
        this.story_array = new Array()

    }

    StoryHub.prototype.addStory = function(story)
    {
        this.story_array.push(story)
    }

    StoryHub.prototype.getStoryByIndex = function(index)
    {
        var story = this.story_array[index]
        if (!story)
        {
            story = new Story()
            story.createEmptyStory()
        }
        return story

    }

    StoryHub.prototype.getStoryById = function(id)
    {
        for (var i = 0, il = this.story_array.length; i < il; i++)
        {
            if (this.story_array[i]['sid'] == id)
            {
                return this.story_array[i]
            }
        }
        return null
    }

    StoryHub.prototype.pickUserStories = function(stories)
    {
        var result = new Array()
        for (var i = 0, il = stories.length; i < il; i++)
        {
            if (stories[i]['uid'] == settings.user['uid'])
            {
                result.push(stories[i])
            }
        }
        return result
    }

    StoryHub.prototype.loadStories = function(callback)
    {
        var self = this
        $.ajax({
            type: 'POST',
            url: '/load-stories/',
            data: {
            },
            success: function(msg){
                msg = JSON.parse(msg)
                
                for (var i = 0, il = msg.length; i < il; i++)
                {
                    var raw_story = msg[i]
                    raw_story['sequencer'] = JSON.parse(raw_story['sequencer'])
                    var story = new Story
                    $.extend(story.info, raw_story)
                    self.story_array.push(story) 
                }
            },
            error: function(msg){
                self.story_array = new Array()
            },
            complete: function(){
                if (callback) callback()
            }
        })
    }

    function Story()
    {
        this.info = {
            'sid': null,
            'uid': null,
            'title': null,
            'story_text': null,
            'sequencer': new Array()
        }
    }

    Story.prototype.createEmptyStory = function()
    {
        this.info['sid'] = 0
        this.info['uid'] = settings.user.getId()
        this.info['title'] = createUUID()
        this.info['story_text'] = createUUID()
        this.info['sequencer'] = new Array()
    }

    Story.prototype.loadsJson = function(jsondata)
    {
        var data = JSON.parse(jsondata)
        $.extend(this.info, data)
    }

    Story.prototype.dumpsJson = function()
    {
        return JSON.stringify(this.info)
    }

    Story.prototype.saveStory = function(callback)
    {
        var self = this
        $.ajax({
            type: 'POST',
            url: '/save-story/',
            data: {
                'story': JSON.stringify(this.info)
            },
            success: function(msg){
                msg = JSON.parse(msg)
                if (msg['sid'])
                {
                    self.info['sid'] = msg['sid']
                }
            },
            error: function(msg){
                self.story_array = new Array()
            },
            complete: function(){
                if (callback) callback()
            }
        })
    }
    

    function createStructure()
    {
        settings.container.innerHTML = ''
        var c_rect = settings.container.getBoundingClientRect()
        var c_width = c_rect.width
        var c_height = c_rect.height
        settings.side_size = Math.ceil(c_width / 20)
        settings.blocks_panel = new BlocksPanel(settings.container,
                                {'height': c_height, 'side_size': settings.side_size })
        /*  //THIS BLOCK HAS TO BE KEPT COMMENTED
        settings.story_holder = document.createElement('div')   
        settings.story_holder.setAttribute('id', 'story-holder')
        settings.container.appendChild(settings.story_holder)

        var ss = document.createElement('div')
        var imm = document.createElement('img')
        imm.src = '/static/img/ss.png'
        ss.setAttribute('class', 'ss')
        ss.appendChild(imm)
        settings.story_holder.appendChild(ss)

        var threedots = document.createElement('div')
        threedots.setAttribute('class', 'threedots')
        var userpanel = settings.userpanel_hub.addUserPanel()
        userpanel.container.appendChild(threedots)
        threedots.onclick = toggleSeveralPanels

        createSpotlightPanel()
        $(settings.container).addClass('unselectable')
        */
        // show nav buttons on hover
        $('.nav-buttons').mouseenter( function() {
            var self = this
            $(this).animate({'opacity': '1'}, 100) 
        }).mouseleave(function(){
            $(this).animate({'opacity': '0'}, 100) 
        });
    }

    function toggleSeveralPanels()
    {
        if (settings.userpanel_hub.visiblePanelsCount() == 1)
        {
            settings.userpanel_hub.addUserPanel()
            settings.userpanel_hub.addUserPanel()
            settings.userpanel_hub.addUserPanel()
        } else {
            settings.userpanel_hub.hideUserPanel()
            settings.userpanel_hub.hideUserPanel()
            settings.userpanel_hub.hideUserPanel()
        }
        render()
    }
    

    function init()
    {
        // connects websocket
        //settings.ws = new Socket()

        /// tries to authenticate user by cookie or creates new
        //settings.user = new User()
        //settings.user.authenticate(init_step_2)
        init_step_4(); //THIS LINE WAS ADDED SO WE CAN SKIP STRAIGHT TO init_step_4
        return
    }

    function init_step_2()
    {
        // tries to get stories from server
        // and then calls init_step_3
        //settings.story_hub = new StoryHub()
        //settings.story_hub.loadStories(init_step_3)
        return 
    }

    function init_step_3()
    {
       // settings.userpanel_hub = new UserPanelHub()
       // settings.userpanel_hub.loadUserPanels(init_step_4)
    }

    function init_step_4()
    {
        settings.block_hub = new BlockHub()
        var img = new Image; img.src = '/assets/ajax.gif' // load ajax loader image to browser cache
        settings.images_loader = new ImagesLoader()
        
        if (settings.first == true)
        {
	    createStructure()
            processOptions()
        }
    }

    function processOptions()
    {
        if (settings.first) settings.first = false
        if (settings.opt.url && settings.opt.url != settings.url)
        {
            settings.url = settings.opt.url
            settings.cid = settings.opt.cid
            settings.collection_name = settings.opt.collection_name
            //settings.blocks_panel.defaultView()
            getBlocks(settings.url, settings.collection_name)
        }
        
        $.extend(settings, settings.opt)

        if (typeof settings.opt.ghost_mode != 'undefined') {
            if (settings.blocks_panel)
            {
                if (settings.opt.ghost_mode == false)
                {
                    settings.blocks_panel.ghostOff()
                    //showMessage('Ghost mode off')
                } else {
                    settings.blocks_panel.update()
                    //showMessage('Ghost mode on')
                }
            }
        }

        if (settings.opt.login)
        {
            settings.user.logIn(settings.opt.login, '', init_step_2)
        }

        if (settings.opt.resize)
        {
            settings.userpanel_hub.setNewBlocksPanelHeight()
        }

        if (settings.opt.sort_by)
        {
            settings.blocks_panel.block_hub.sortBy(settings.opt.sort_by)
            //showMessage('Sorted ' + settings.opt['sort_name'])
            settings.blocks_panel.update()
        }

        if (settings.opt.sort_order)
        {
            settings.blocks_panel.block_hub.sortDirection(settings.opt.sort_order)
            //showMessage('Sorted ' + settings.opt['sort_name'])
            settings.blocks_panel.update()
        }

        if (settings.opt.toggleuserpanel) // hide/show user panels
        {
            if (settings.userpanel_hub.visiblePanelsCount() == 0)
            {
                settings.userpanel_hub.addUserPanel()
            } else {
                while(settings.userpanel_hub.visiblePanelsCount())
                {
                    settings.userpanel_hub.hideUserPanel()
                }
            }
            settings.userpanel_hub.setNewBlocksPanelHeight()
        }

        if (typeof settings.opt.collapse !== 'undefined') // hide/show user panels
        {
            if (settings.opt.collapse == true)
            {
                while(settings.userpanel_hub.visiblePanelsCount())
                {
                    settings.userpanel_hub.hideUserPanel()
                }
            } else {
                if (settings.userpanel_hub.visiblePanelsCount() == 0)
                {
                    settings.userpanel_hub.addUserPanel()
                }
            }

            settings.userpanel_hub.setNewBlocksPanelHeight()
        }

        if (settings.opt.show_minimap)
        {
            toggleMinimap()
            //showMessage('Minimap opened')
        }
        
        if (settings.opt['default-view'])
        {
            settings.blocks_panel.defaultView()
        }

        if (settings.opt['message'])
        {
            //showMessage(settings.opt['message'])
        }        
    }

    function render()
    {
        settings.images_loader.reset()
        /*for (var i = 0, il = settings.userpanel_hub.count(); i < il; i++) //THIS BLOCK HAS TO BE KEPT COMMENTED
        {
            settings.userpanel_hub.getUserPanel(i).update()
        }*/
        settings.blocks_panel.update()
    }

    var settings = {
        first: true,
        container: null,
        block_hub: null,
        url: null,
        drag_block: null,
        images_loader: null,
        blocks_panel: null,
        ghost_mode: false,
        story_array: new Array(),
        userpanel_hub: new Array(),
        user: null,
        ws: null,
        sid: 1,
    }

    $.fn.spatialc = function() 
    {
        if (arguments.length > 0)
        {
            settings.opt = arguments[0]
        }
        if (settings.first)
        {
            settings.container = $(this)[0]
            init()
            return
        }

        if (arguments.length > 0)
        {
            processOptions()
        }
    }

    function getBlocks(url)
    {
        $('#debug').html('waiting for server json response...')
        $.ajax({
            type: 'GET',
            url: url,
            data: {
                //'type': 'thumbnail',
                'format': 'json',
                //'csrfmiddlewaretoken': $('input[name="csrfmiddlewaretoken"]').val(),
            },
            success: function(msg){
                if (typeof msg === 'string')
                    msg = JSON.parse(msg)
                $('#debug').html($('#debug').html() + ' done')
                getBlocksContinue(msg)
                
            },
            error: function(msg){
                $('#debug').html($('#debug').html() + ' failed: ' + msg)
                alert('Error getting data from server: ' + msg)
            }
        });
    }

    function getBlocksContinue(response)
    {
        for (var i = 0, il = response.length; i < il; i++)
        {
            if (response[i].thumbnail == null) continue
            settings.block_hub.addBlock(new Block(response[i].id, settings.block_hub.count(), response[i].thumbnail, response[i].title, settings.cid, response[i].parsed))
        }
        settings.blocks_panel.setBlockHub(settings.block_hub)
        render()
    }
    
    function createSpotlightPanel()
    {
        settings.shade_div = document.createElement('div')
        settings.shade_div.setAttribute('class', 'spatialc-shade-div')
        $('body').append(settings.shade_div)
        var spotlight = document.createElement('div')
        spotlight.setAttribute('class', 'spotlight')
        $(settings.shade_div).append(spotlight)
        $(settings.shade_div).click(function(e){ if( e.target === this ) $(this).css('display', 'none') })

        var left_panel = document.createElement('div')
        $(left_panel).css({
            'width': '49%',
            'float': 'left',
            'height': '100%',
        })
        var right_panel = left_panel.cloneNode()

        var clear = document.createElement('div')
        clear.style.clear = 'both'

        spotlight.appendChild(left_panel)
        spotlight.appendChild(right_panel)
        spotlight.appendChild(clear)

        settings.display_block = []
        settings.display_block.title = document.createElement('h1')
        settings.display_block.author = document.createElement('h3')
        settings.display_block.subjects = document.createElement('h3')
        settings.display_block.topics = document.createElement('h4')
        settings.display_block.image = document.createElement('img')
        left_panel.appendChild(settings.display_block.title)
        left_panel.appendChild(settings.display_block.author)
        left_panel.appendChild(settings.display_block.subjects)
        left_panel.appendChild(settings.display_block.topics)
        right_panel.appendChild(settings.display_block.image)
    }

    function createUUID() {
        var s = []
        var hexDigits = "0123456789abcdef"
        for (var i = 0; i < 36; i++) {
            s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
        }
        s[14] = "4"
        s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1)
        s[8] = s[13] = s[18] = s[23] = "-"

        var uuid = s.join("")
        return uuid
    }
    
    function getCookie(cname)
    {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for(var i=0; i<ca.length; i++) 
        {
            var c = ca[i].trim();
            if (c.indexOf(name)==0) return c.substring(name.length,c.length);
        }
        return "";
    }

    function setCookie(cname,cvalue,exdays)
    {
        var d = new Date();
        d.setTime(d.getTime()+(exdays*24*60*60*1000));
        var expires = "expires="+d.toGMTString();
        document.cookie = cname + "=" + cvalue + "; " + expires;
    }

}( jQuery ));

