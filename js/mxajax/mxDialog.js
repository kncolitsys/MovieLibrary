mxAjax.Dialog = Class.create();
mxAjax.Dialog.prototype = {
  	initialize: function(options) {
        if (!$("dialogbg")) initDialog();
    	this.setOptions(options);
    	this.setListeners();
    	this.container = this.createDialogBox();
  	},

  	setOptions: function(options) {
    	this.options = Object.extend({
      		id: options.id ? options.id : "",
      		title: options.title ? options.title : "Information",
      		body: options.body ? options.body : "you want to continue?",
      		bodyalign: options.bodyalign ? options.bodyalign : "center",
      		button: options.button ? options.button : [{key:"0", value:"Ok"}],
      		buttonalign: options.buttonalign ? options.buttonalign : "center",
      		icon: options.icon ? options.icon : "../core/images/dialog/information.gif",
      		eventType: options.eventType ? options.eventType : "click"
    	}, options || {});
    	
  	},
  	
  	setListeners: function() {
		if (this.options.source != "") {
	    	Event.observe($(this.options.source),
	      		this.options.eventType,
	      		this.execute.bindAsEventListener(this),
	      		false);
	    	eval("$(this.options.source).on"+this.options.eventType+" = function(){return false;};");
	    }
  	},
  	
  	execute: function(e) {
  	     currDialogObj = this;
  	     showDialog(this.container,this.options.width,this.options.height);
  	},
  	
	createElementEx: function (options) {
    	var obj = document.createElement(options.tag);
    	if (options.id) obj.id = options.id;
    	if (options.className) obj.className = options.className;
    	if (options.style) this.applyStyle(obj, options.style);
    	if (options.type) obj.type = options.type;
    	if (options.content) obj.innerHTML = options.content;
    	return obj;
    },
			
	applyStyle: function(obj, styleList) {
		var _styleArr = styleList.split(";");
		var ctr= 0;
		var _elements = "";
		for (ctr=0; ctr < _styleArr.length; ctr++) {
			_elements = _styleArr[ctr].split(":");
			obj.style[_elements[0].replace(/^\s*|\s*$/g,"")] = _elements[1].replace(/^\s*|\s*$/g,"");
		}
	},
			
	createDialogBox: function() 
	{
        var obj = this;
		var container = this.createElementEx({tag:"div", className:"panel-container dialog simple-dialog", style:"visibility: visible"});
		dialog = this.createElementEx({tag:"div", className:"overlay panel", style:"visibility: inherit"});
		header = this.createElementEx({tag:"div", className:"hd", style:"cursor: auto", content:obj.options.title});

		//body = this.createElementEx({tag:"div", className:"bd", style:"textAlign:" + obj.options.bodyalign});
		body = this.createElementEx({tag:"div", className:"bd body"});
		if (obj.options.icon != "") {
            img = document.createElement("img");
            img.src = obj.options.icon;
            img.className = "icon";
            //this.applyStyle(img, "float:left;marginRight:10px");
            body.appendChild(img);
        }
        text = document.createElement("span");
        text.innerHTML = obj.options.body;
        body.appendChild(text);
        
		footer = this.createElementEx({tag:"div", className:"ft", style:"textAlign:" + obj.options.buttonalign ,  content:""});
		
		btn = "";
		for (i=0; i < obj.options.button.length; i++) {
		  _data = obj.options.button[i];
		  _default = "";
		  if (_data.isdefault == true) {
		      _default = 'class="default"';
		  }
		  btn += '<button ' + _default + ' onclick="modelBtnClicked(\'' + _data.key +  '\')" type="button">' + _data.value + '</button>';
		}
		btnGroup = this.createElementEx({tag:"span", className:"button-group", content:""});
		btnGroup.innerHTML = btn;
		footer.appendChild(btnGroup);
		
		if (obj.options.title != "") dialog.appendChild(header);
		dialog.appendChild(body);
		dialog.appendChild(footer);

		container.appendChild(dialog);
		return container;
	}
}

function  modelBtnClicked(btnValue, closed) 
{
    closeDialog();
    if (currDialogObj.options.postFunction != null) currDialogObj.options.postFunction(btnValue);
}



// Modal Dialog Box
// copyright 8th July 2006 by Stephen Chapman
var currDialogObj = "";
function dialogScrollFix(){var obol=$('dialogbg');obol.style.top=Window.getPosTop()+'px';obol.style.left=Window.getPosLeft()+'px'}
function dialogSizeFix(){var obol=$('dialogbg');obol.style.height=Window.getWindowHeight()+'px';obol.style.width=Window.getWidth()+'px';}
function dialogInf(h){
    tag=document.getElementsByTagName('select');for(i=tag.length-1;i>=0;i--)tag[i].style.visibility=h;
    tag=document.getElementsByTagName('iframe');for(i=tag.length-1;i>=0;i--)tag[i].style.visibility=h;
    tag=document.getElementsByTagName('object');for(i=tag.length-1;i>=0;i--)tag[i].style.visibility=h; }
function showDialog(dialog, wd, ht) {
    var h='hidden';var b='block';var p='px';var obol=$('dialogbg');var obbxd = $('__mbd');obbxd.innerHTML = dialog.innerHTML;obol.style.height=Window.getWindowHeight()+p;obol.style.width=Window.getWidth()+p;obol.style.top=Window.getPosTop()+p;obol.style.left=Window.getPosLeft()+p;
    obol.style.display=b;var tp=Window.getPosTop()+((Window.getWindowHeight()-ht)/2)-12;var lt=Window.getPosLeft()+((Window.getWidth()-wd)/2)-12;
    var obbx=$('__mbox');obbx.style.top=(tp<0?0:tp)+p;obbx.style.left=(lt<0?0:lt)+p;obbx.style.width=wd+p;obbx.style.height=ht+p;dialogInf(h);obbx.style.display=b;
    return false; }
function closeDialog(){var v='visible';var n='none';$('dialogbg').style.display=n;$('__mbox').style.display=n;dialogInf(v);document.onkeypress='';}
function initDialog() {
    var ab='absolute';var n='none';var obody=document.getElementsByTagName('body')[0];var frag=document.createDocumentFragment();
    var obol=document.createElement('div');obol.setAttribute('id','dialogbg');obol.style.display=n;obol.style.position=ab;obol.style.top=0;obol.style.left=0;obol.style.zIndex=998;obol.style.width='100%';frag.appendChild(obol);
    var obbx=document.createElement('div');obbx.setAttribute('id','__mbox');obbx.style.display=n;obbx.style.position=ab;obbx.style.zIndex=999;
    var obl=document.createElement('span');obbx.appendChild(obl);var obbxd=document.createElement('div');obbxd.setAttribute('id','__mbd');obl.appendChild(obbxd);frag.insertBefore(obbx,obol.nextSibling);obody.insertBefore(frag,obody.firstChild);window.onscroll = dialogScrollFix;window.onresize = dialogSizeFix;
}