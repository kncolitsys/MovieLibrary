<html>
	<head>
		<title>Returning Data from CF page</title>
		<cfoutput>
		<script type='text/javascript' src='../core/js/prototype.js'></script>
		<script type='text/javascript' src='../core/js/mxAjax.js'></script>
		<script type='text/javascript' src='../core/js/mxDialog.js'></script>
		</cfoutput>
		<script language="javascript">
			var url = "<cfoutput>#ajaxUrl#</cfoutput>";
			var container = "";

			function init() {
				new mxAjax.Dialog({
					source:"id1", 
					width:"200",
					height:"100",
					body: "You are using mxAjax",
					postFunction: handleData
				});

				new mxAjax.Dialog({
					source:"id2", 
					width:"200",
					height:"100",
					title:"Question",
					body: "Do you like snow?",
      				button: [{key:"1", value:"Yes", isdefault:true}, {key:"2", value:"No"}, {key:"3", value:"Maybe"}],
      				buttonalign:"right", 
					icon:"../core/images/dialog/help.gif",      				
					postFunction: handleData
				});

				new mxAjax.Dialog({
					source:"id3", 
					title:"",
					width:"200",
					height:"100",
					body: "Do you like snow?",
      				button: [{key:"1", value:"Yes", isdefault:true}, {key:"2", value:"No"}, {key:"3", value:"Maybe"}],
					icon:"../core/images/dialog/help.gif",      				
					postFunction: handleData
				});

				new mxAjax.Dialog({
					source:"id4", 
					width:"300",
					height:"220",
					title:"Critical Notice!",
					body: "<b>Limited Virtual Memory</b><br><br>Your system is running without a properly sized paging file. Please use the virtual memory option of the System applet in the Control Panel to create a paging file, or to increase the initial size of your paging file.<br><br>",
					icon:"../core/images/dialog/error.gif",      				
      				button: [{key:"1", value:"What should i do?", isdefault:true}, {key:"2", value:"Whatever"}],
					postFunction: handleData
				});
				
				function handleData(response) {
					alert("Selection value : " + response);
				}
			}
			addOnLoadEvent(function() {init();});
		</script>
		
	    <link rel="stylesheet" type="text/css" href="container.css">

		<style type="text/css">
	        .body {
	        	font-size:15px;
	        }
	        
	        .body .icon {
				background-repeat:no-repeat;
				width:16px;
				height:16px;
				margin-right:10px;
	        }
			
			#dialogbg{background-image: url(../core/images/overlay.png);}
			* html #dialogbg{background-image:none; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src="../core/images/overlay.png", sizingMethod="scale");}
		</style>		
	</head>
	<body>
		
		
		<h1>Using mxDialog</h1>
		<br><br>
		<input type="button" id="id1" value="Simple Dialog"/>
		<br><br>
		<input type="button" id="id2" value="Multiple Options Dialog"/>
		<br><br>
		<input type="button" id="id3" value="Dialog without title"/>
		<br><br>
		<a href="javascript:\\" id="id4">Multiline dialog</a>
		<br><br><br><br><br><br><br>
		
		
		
	</body>
</html>