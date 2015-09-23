//http://www.amazon.com/Britney-Spears/artist/B000APFTTM/102-6273530-2988129
mxAjax.Rotator = Class.create();
mxAjax.Rotator.prototype = {
  	initialize: function(options) {
    	this.setOptions(options);
    	this.setListeners();
    	//w/h
        this.currentHeader = "";
        this.isProcessing = false;
        this.lastTimeOutSwapElementLeftPos = 0;
  	},

  	setOptions: function(options) {
    	this.options = Object.extend({
      		id: options.id ? options.id : "",
      		selectedData: options.selectedData ? options.selectedData : 0,
      		headerImageDimension: options.headerImageDimension ? options.headerImageDimension : [160,160],
      		bodyImageDimension: options.bodyImageDimension ? options.bodyImageDimension : [80,80],
      		timeOut: options.timeOut ? options.timeOut : 500,
      		fireInitEvent: options.fireInitEvent ? options.fireInitEvent : true,
      		eventType: options.eventType ? options.eventType : "click"
    	}, options || {});
    	
  	},
  	
  	setListeners: function() {
  	},
  	
  	
  	createRotator: function()
  	{
  	    var container = $(this.options.source);
  	    var header = container.getElementsByTagName('div')[0];
  	    var body = container.getElementsByTagName('div')[1];
  	    
        //var header = $("current");
        //var body = $("imgContainer");
        
        var ctr = -1;
        var obj = this;
  	    for (i=0; i < this.options.data.length; i++)
        {
            href = this.createHref();
            if (this.options.selectedData != i)
            {
                ctr++;
                left = 10;
                img = document.createElement("img");
                img.src = this.options.data[i];
                img.className = "icon";
                img.width= this.options.bodyImageDimension[0];
                img.height= this.options.bodyImageDimension[1];
                img.id = this.options.source + "img_" + i;
                this.applyStyle(img, "position:absolute;left:" + (left+((10+this.options.bodyImageDimension[0])*ctr)) + "px");
                href.appendChild(img);
                eval("href.onclick=function(){obj.onEvent('click','" + img.id + "')};");
                eval("href.onmouseover=function(){obj.onEvent('mouseover','" + img.id + "')};");
                eval("href.onmouseout=function(){obj.onEvent('mouseout','" + img.id + "')};");
                body.appendChild(href);
            } else {
                img = document.createElement("img");
                img.src = this.options.data[i];
                img.className = "icon";
                img.width= this.options.headerImageDimension[0];
                img.height= this.options.headerImageDimension[1];
                img.id = this.options.source + "img_" + i;
                this.applyStyle(img, "padding:0px;position:absolute;left:" + this.getLeftPosOfHeaderImage() + "px");
                href.appendChild(img);
                eval("href.onclick=function(){obj.onEvent('click','" + img.id + "')};");
                eval("href.onmouseover=function(){obj.onEvent('mouseover','" + img.id + "')};");
                eval("href.onmouseout=function(){obj.onEvent('mouseout','" + img.id + "')};");
                header.appendChild(href);
                
                this.currentHeader = img.id;
            }
        }
        if (this.options.fireInitEvent) {
            if (this.options.postFunction != null) this.options.postFunction(this.options.selectedData);
        }        
  	},
  	
  	getLeftPosOfHeaderImage: function()
  	{
        var container = $(this.options.source);
        
        _cWidth = container.offsetWidth
        //console.log(_cWidth);
        return ( (_cWidth - this.options.headerImageDimension[0]) / 2)
  	},
  	
  	swapHeader: function(elementName) 
  	{
        this.isProcessing = true;
        var swapWithElement = elementName;
		var swpCurrentX = $(swapWithElement).offsetLeft;
		var swpCurrentY = $(swapWithElement).offsetTop;
		var obj = this;

		new Rico.Effect.SizeAndPosition(swapWithElement,$(obj.currentHeader).offsetLeft, $(obj.currentHeader).offsetTop, this.options.headerImageDimension[0], this.options.headerImageDimension[1], 500, 5);				
		new Rico.Effect.FadeTo( obj.currentHeader, .2, 500,5, {
			complete:function() {
				style = $(obj.currentHeader).style;
				style.left = swpCurrentX;
				style.top = swpCurrentY;
				style.width = obj.options.bodyImageDimension[0];
				style.height = obj.options.bodyImageDimension[1];
				style.filter = "";
				style.opacity = 100;
				obj.currentHeader = swapWithElement;
				obj.isProcessing = false;
                if (obj.options.postFunction != null) obj.options.postFunction(elementName.split("_")[1]);				
			}
		});
  	},
  	
  	onEvent: function(event, elementID) 
  	{
        obj = this;
        if (elementID != obj.currentHeader) {
            if (!this.isProcessing) {
                if (event == "click") {
                    if (obj.timeout != null)
                    {
                        clearTimeout(obj.timeout);
                    }
                    obj.lastTimeOutSwapElementLeftPos = $(elementID).offsetLeft;
                    this.swapHeader(elementID);
                } else if (event =="mouseover") {
                    //console.log (" last =>" + obj.lastTimeOutSwapElementLeftPos  + "  now =>" + $(elementID).offsetLeft);
                    if ( obj.lastTimeOutSwapElementLeftPos != $(elementID).offsetLeft) 
                    {
                        obj.lastTimeOutSwapElementLeftPos = 0;
                        obj.timeout = setTimeout(
                            function () {
                                obj.lastTimeOutSwapElementLeftPos = $(elementID).offsetLeft;
                                obj.swapHeader(elementID);
                            }
                        , obj.options.timeOut);
                    }
                } else if (event =="mouseout") {
                    if (obj.timeout != null)
                    {
                        clearTimeout(obj.timeout);
                    }
                }
            }
        }
  	},
  	
	createHref: function()
	{
		var elem = document.createElement( "a" );
		elem.href = "#";
		return elem;
	},  	
			
	applyStyle: function(obj, styleList) {
		var _styleArr = styleList.split(";");
		var ctr= 0;
		var _elements = "";
		for (ctr=0; ctr < _styleArr.length; ctr++) {
			_elements = _styleArr[ctr].split(":");
			obj.style[_elements[0].replace(/^\s*|\s*$/g,"")] = _elements[1].replace(/^\s*|\s*$/g,"");
		}
	}
			
}
