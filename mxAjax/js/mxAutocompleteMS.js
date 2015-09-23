mxAjax.ExtendedAutocompleterMS = Class.create();
Object.extend(Object.extend(mxAjax.ExtendedAutocompleterMS.prototype, Autocompleter.Base.prototype), {
	initialize: function(element, update, paramArgs, paramFunction, parser, id, options) {
    	this.baseInitialize(element, update, options);
    	this.options.asynchronous  	= true;
    	this.options.onComplete    	= this.onComplete.bind(this);
		this.paramArgs				= paramArgs;
		this.paramFunction			= paramFunction;
    	this.parser                 = parser;
		this.id 					= id;
  	},


  	getUpdatedChoices: function() {
		this.oParam = (this.paramArgs != null) ? this.paramArgs : this.paramFunction(this.id);
    	entry = encodeURIComponent(this.options.paramName) + '=' + encodeURIComponent(this.getToken());
		this.oParam.setDefaultParam(entry);

		this.options.parameters = this.oParam.getUrlParam();
		this.options.postBody = (this.oParam.getHttpMethod() == "post") ? this.oParam.getPostData() : '';
		this.options.method = this.oParam.getHttpMethod();

    	new Ajax.Request(this.oParam.getUrl(), this.options);
  	},

  	onComplete: function(request) {
    	responseText = this.oParam.removeUnwantedDataFromRequest(request.responseText);
		jsonObject = this.parser.parse(responseText);
		this.updateChoices( this.buildDopDownList(this.parser.itemList) );
  	},
	
	buildDopDownList: function(JSKeyValue) {
		var ul = '<ul>';
	  	for (var i=0; i< JSKeyValue.length; i++) {
			ul += '<li id="' + JSKeyValue[i].key + '">' + JSKeyValue[i].value + '</li>';
		}
		ul += '</ul>';
		return ul;
	}
});

mxAjax.AutocompleteMS = Class.create();
mxAjax.AutocompleteMS.prototype = {
	initialize: function(options) {
    	this.setOptions(options);
    	$(this.options.source).setAttribute("autocomplete", "off");
	    this.selectionList          = new Array()

    	// DIV tag to show drop down.
    	new Insertion.After(this.options.source, '<div id="' + this.options.divElement + '" class="' + this.options.className + '"></div>');
    	this.execute();
  	},

  	setOptions: function(options) {
		this.options = Object.extend({
			id: options.id ? options.id : "",
      		divElement: "auto_" + options.source,
      		indicator: options.indicator || '',
			parser: options.parser ? options.parser : new mxAjax.CFArrayToJSKeyValueParser(),
      		handler: options.handler ? options.handler : this.handler,
			flexWidth: options.flexWidth || false
    	}, options || {});
  	},

  	execute: function(e) {
    	if (this.options.preFunction != null) this.options.preFunction({id:this.options.id, source:this.options.source, target:this.options.target});
		var obj = this; // required because 'this' conflict with Ajax.Request
    	var aj = new mxAjax.ExtendedAutocompleterMS(
    		this.options.source,
			this.options.divElement,
			this.options.paramArgs, 
			this.options.paramFunction,
			this.options.parser, 
			this.options.id, {
				minChars: obj.options.minimumCharacters,
				tokens: obj.options.appendSeparator,
				indicator: obj.options.indicator,
				evalScripts: true,
				onShow: function(element, update){ 
      				if(!update.style.position || update.style.position=='absolute') {
        				update.style.position = 'absolute';
        				Position.clone(element, update, {setHeight: false, offsetTop: element.offsetHeight, setWidth:!obj.options.flexWidth});
      				}
      				Effect.Appear(update,{duration:0.15});
				},
				onFailure: function(request) {
					if (obj.options.errorFunction != null) 
						obj.options.errorFunction(responseText, {id:obj.options.id, object:"mxAutocompleteMS"});
					else 
						mxAjax.onError(request.responseText, {id:obj.options.id, object:"mxAutocompleteMS"});
				},
				afterUpdateElement: function(inputField, selectedItem) {
                	obj.options.handler(null,null, {
						source: obj.options.source,
						selectedItem: selectedItem,
						tokens: obj.options.appendSeparator,
						target: obj.options.target,
						selectionDisplay: obj.options.selectionDisplay,
						inputField: inputField,
						id: obj.options.id,
						postFunction: obj.options.postFunction,
						selectionList:obj.selectionList,
						context: obj
				});
			}
		});
  	},

  	handler: function(response, json, options) {
    	if (options.selectionDisplay) {
      		options.selectionList[options.selectionList.length] = new Array(options.selectedItem.id,options.selectedItem.innerHTML); 
      		options.context.displayList(options);
      	    options.context.displayListEvent(options);	
    	}
    	$(options.source).value ="";

    	if (options.postFunction != null) {
      		//Disable onupdate event handler of input field
      		//because, postFunction can change the content of
      		//input field and get into eternal loop.
      		var onupdateHandler = $(options.inputField).onupdate;
      		$(options.inputField).onupdate = '';
      		options.postFunction(response,json,options);
				  
      		//Enable onupdate event handler of input field
      		$(options.inputField).onupdate = onupdateHandler;
    	}
  	},
  	
	displayList: function(options)
	{
        dataToPost = "";
  		selectionDisplay = $(options.selectionDisplay);
  		displayData = "<table>";
  		for (i=0; i < options.selectionList.length; i++)
  		{
  		    if ((options.selectionList[i][0]) != "") 
  		    {
  		        if (dataToPost.length > 0) 
  		            dataToPost += "," + options.selectionList[i][0];
  		        else
  		            dataToPost = options.selectionList[i][0];
  		        
      		    displayData += "<tr><td width='100%'>"; 
      		    displayData += options.selectionList[i][0] + " - " + options.selectionList[i][1];
      		    displayData += "</td><td width='20'>";
      		    displayData += "<a href='#' id='acms" + i + "'>delete</a>";
      		    displayData += "</td></tr>";
            }
  		}
  		displayData += "</table>";
  		selectionDisplay.innerHTML = displayData;
  		$(options.target).value = dataToPost;
	},
	
	displayListEvent: function(options) 
	{
        selectionDisplay = $(options.selectionDisplay);
    	for (i=0; i < selectionDisplay.getElementsByTagName('a').length; i++) {
    	  var link = selectionDisplay.getElementsByTagName('a')[i];
    	  eval("link.onclick=function(){options.context.acmsdelete('" + link.id + "', options,  options.context)};");
    	}
	},

  	acmsdelete: function(id, options, context) 
  	{
  	     id = parseInt(id.substr(4,4));
  	     options.selectionList[id][0] = "";
  	     context.displayList(options);
  	     context.displayListEvent(options);
  	}
};

