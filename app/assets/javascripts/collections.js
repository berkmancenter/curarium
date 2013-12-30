function configureCollection() {
		$('#output .field_wrapper').droppable({
			drop : field_drop,
		});

		$('#output .field_wrapper').click(function(e) {
			console.log($(this).data('path').toString());
		});

		$('#parse').submit(function(e) {
			e.preventDefault();
			$('#parsed').empty();
			try {
				//try to parse the record
				record = JSON.parse($("#json").val());
				//append parsed record to the center column
				$('#parsed').append(printRecord(record));
				//make field values draggable and field labels collapsable
				$('#parsed dd').draggable({
					helper : "clone"
				});
				$('#parsed dd').attr('title', 'drag me to a field');
				$('#parsed dt').click(function() {
					$(this).next('dl').toggle();
				});
			} catch (e) {
				$('#parsed').append('invalid json');
			}
		});

		$('form#add_field').submit(function(e) {
			e.preventDefault();
			var field_name = $(this).find('input[name=field_name]').val();
			var new_field = $('<div>').attr('class', 'field_wrapper').attr('id', field_name).droppable({
				drop : field_drop,
			});
			var title = $('<p>').append(field_name);
			$(new_field).append(title);
			var close = $('<div>').attr('class', 'close').append('X').click(function(e) {
				$(this).parent().remove();
			});
			$(new_field).append(close);
			$("#output form#add_field").before(new_field);
		});

		$('form#submit_configuration').submit(function(e) {
			e.preventDefault();
			var record = {};
			$('.field_wrapper').each(function() {
				var field = $(this).attr('id');
				var value = $(this).data('path');
				record[field] = value;
			});
			$("#collection_configuration").val(JSON.stringify(record));
		});
	}

	var field_drop = function(e, d) {//specifies the "droppable" behavior when dragging fields from the original records into the custom curarium fields. Reads the path, generates a form for modifying numeric values and gives a sample output.
		var path = $(d.draggable).data('path');
		var field = $('<form>');
		for (p in path) {
			if ( typeof path[p] == 'string') {
				var part = $("<input readonly>").attr('class', 'part').attr('type', 'hidden').attr('value', path[p]);
				var label = $("<span>").append(path[p]);
				$(field).append(label);
			} else {
				var part = $("<select>").attr('class', 'part').change(function(e) {
					var path = [];
					$(this).parent().children('select, input').each(function() {

						var val = $(this).val();

						if (isNaN(val)) {
							path.push(val);
						} else {
							path.push(parseInt(val, 10));
						}

					});
					$(this).parent().parent().find('.value').html(traceField(record, path));
					$(this).parent().parent().data('path', path);
				});
				var option01 = $('<option>').attr('value', path[p]).append(path[p]);
				var option02 = $('<option>').attr('value', "*").append("*");
				part.append(option01).append(option02);
			}

			$(field).append(part);
			$(this).data('path', path);
		}
		$(this).append(field);
		var value = $("<div class='value'>").append(traceField(record, path));
		$(this).append(value);
	};

	function traceField(object, path) {//a test function to use an array of keys to read a JSON structure looking for the correspondent value. It should be transposed into Ruby to work as back end.
		var field;
		if (object.hasOwnProperty(path[0])) {
			var current = object[path[0]];
			if (path.length === 1) {
				return current;
			} else {
				if (Array.isArray(current) && path[1] === "*") {//if, instead of being given a numeric index, an Array is given a "*" as a key, it will iterate through all the items in the Array.
					field = [];
					for (var i = 0; i < current.length; i++) {
						npath = path.slice(1);
						npath[0] = i;
						field.push(traceField(current, npath));
					}
				} else {
					field = traceField(current, path.slice(1));
				}
			}
			return field;
		} else {
			return null;
		}
	}

	function printRecord(json, path) {//this function takes a JSON structure and outputs a nested definition list. Keys and Array indexes are converted into Definition Terms(<dt>), Objects and Arrays into Definition Lists(dl) and numeric and string values into Definition Definitions(<dd>)

		var path = path || [];

		var localpath = path.slice(0);
		var item;

		if ( typeof json === 'object') {
			item = $('<dl>');
			if (Array.isArray(json)) {
				item.attr('class', 'array');
			} else {
				item.attr('class', 'object');
			}

			for (var i in json) {
				if (json.hasOwnProperty(i)) {
					var term = $('<dt>').append(i + ":");
					item.append(term);
					if (isNaN(i)) {
						localpath.push(i);
					} else {
						localpath.push(parseInt(i));
					}
					item.append(printRecord(json[i], localpath));
					if ( typeof json[i] != 'object') {
						item.append("<br>");
					}
					localpath = path.slice(0);
				}
			}
			return item;
		} else {
			var title = localpath.toString();
			item = $('<dd>').data('path', localpath);
			item.append(json);
			return item;
		}
	};