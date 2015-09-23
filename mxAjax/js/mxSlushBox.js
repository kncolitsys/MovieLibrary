mxAjax.SlushBox = Class.create();
mxAjax.SlushBox.prototype = {
	initialize: function(options) {
		this.setOptions(options);
  	},

  	setOptions: function(options) {
    	this.options = Object.extend({
      		id: options.id ? options.id : "",
      		executeOnLoad: options.executeOnLoad ? options.executeOnLoad : false,
      		eventType: options.eventType ? options.eventType : "change",
      		parser: options.parser ? options.parser : new mxAjax.CFArrayToJSKeyValueParser(),
      		handler: options.handler ? options.handler : this.handler,
      		controls: [options.leftControl, options.rightControl]
    	}, options || {});
    	
		dndMgr.registerDropZone( new Rico.Dropzone($(options.leftControl)));
	  	dndMgr.registerDropZone( new Rico.Dropzone($(options.rightControl)));
  	},

	dblClick: function(e)
	{
		var element = Event.element(e);
		if (element.title == this.options.leftControl) {
			element.title = this.options.rightControl;
			target = $(this.options.rightControl);
		} else {
			element.title = this.options.leftControl;
			target = $(this.options.leftControl);
		}
		target.appendChild(element);
		this.updateSelectionKey();
	},
  	
  	loadData: function(data) {
    	for (var i=0; i<data.items.length; i++) 
    	{
    		selectElement = this.createSelectElement("slushid" + data.items[i].key, data.items[i].value);
	    	Event.observe(selectElement, "dblclick", this.dblClick.bindAsEventListener(this), false);
    		
    		if (data.items[i].location != undefined) {
    			if (data.items[i].location == "rightControl") {
    				selectElement.title = this.options.rightControl;
    				$(this.options.rightControl).appendChild(selectElement);
    			} else
    				$(this.options.leftControl).appendChild(selectElement);
    		} else {
	    		$(this.options.leftControl).appendChild(selectElement);
    		}
			dndMgr.registerDraggable( new CustomDraggable($("slushid" + data.items[i].key), data.items[i].value,  this.options.controls, this) );
    	}
    	this.updateSelectionKey();
  	},
  	
  	updateSelectionKey: function()
  	{
    	$(this.options.leftControlSelection).value = this.getSelectedKey(this.options.leftControl);
    	$(this.options.rightControlSelection).value = this.getSelectedKey(this.options.rightControl);
  	},
  	
  	getSelectedKey: function(control)
  	{
		var elem = $(control);
		var data = "";
		var id="";
		for (i=0; i < elem.childNodes.length; i++) {
			if (elem.childNodes[i].id != undefined) {
				id =  elem.childNodes[i].id.substr(7);
				data += (data == "") ? id : "," + id;
			}
		}
		return data;
  	},

	createSelectElement: function(id, content)
  	{
		var obj = this;
		var input = Try.these(
      		function() {
      			var _obj = document.createElement("<span id='" + id + "' class='nameSpan' title='" + obj.options.leftControl + "'>" + content + "</span>");
      			_obj.innerHTML = content;
      			return _obj;
      		},
      		function() { 
      			var inp = document.createElement("span");
				inp.setAttribute("id", id);
				inp.setAttribute("class", "nameSpan");
				inp.setAttribute("title", obj.options.leftControl);
				inp.innerHTML = content;
      			return inp;
      		} 
		)|| false;
		return input;
  	}
  	
};



/**
 *  'CustomDraggable' object which extends the Rico.Draggable to
 *  override the behaviors associated with a draggable object...
 *
 **/
var CustomDraggable = Class.create();
CustomDraggable.prototype = (new Rico.Draggable()).extend( {
	   initialize: function( htmlElement, name, controls, slushBoxObj ) {
	      this.type        = 'Custom';
	      this.htmlElement = $(htmlElement);
	      this.name        = name;
	      this.controls	   = controls; 
	      this.slushBoxObj = slushBoxObj;
	   },
	
	   select: function() {
	      this.selected = true;
	      var el = this.htmlElement;
	
	      // show the item selected.....
	      el.style.color           = "#ffffff";
	      el.style.backgroundColor = "#08246b";
	      el.style.border          = "1px solid blue";
	   },
	
	   deselect: function() {
	      this.selected = false;
	      var el = this.htmlElement;
	      el.style.color           = "#2b2b2b";
	      el.style.backgroundColor = "transparent";
	      el.style.border = "0px solid #ffffee";
	   },
	
	   startDrag: function() {
	      var el = this.htmlElement;
	   },
	
	   cancelDrag: function() {
	      var el = this.htmlElement;
	   },
	
	   endDrag: function() {
	      var el = this.htmlElement;
	      for (var ctr=0; ctr < this.controls.length; ctr++) {
	      	 if (this.controls[ctr] != el.title) {
	      	 	el.title = this.controls[ctr];
	      	 	break;
	      	 }
	      }
	      this.slushBoxObj.updateSelectionKey();
		  return el;
	   },
	
	   getSingleObjectDragGUI: function() {
	      var el = this.htmlElement;
	      var div = document.createElement("div");
	      div.className = this.slushBoxObj.options.cssClass.draggable;
	      div.style.width = (this.htmlElement.offsetWidth - 10) + "px";
	      div.setAttribute("title", el.title);
	      
	      new Insertion.Top( div, this.name );
	      return div;
	   },
	
	   getDroppedGUI: function() {
	      return this.htmlElement;
	   },
	
	   toString: function() {
	      return this.name;
	   }
});	
