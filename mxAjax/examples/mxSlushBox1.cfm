<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Populating Drop down list with Coldfusion Array</title>
		<cfoutput>
		<script type='text/javascript' src='../core/js/prototype.js'></script>
		<script type='text/javascript' src='../core/js/scriptaculous.js'></script>
		<script type='text/javascript' src='../core/js/mxAjax.js'></script>
		<script type='text/javascript' src='../core/js/mxSlushBoxBundle.js'></script>
		</cfoutput>
		
		<style type="text/css">
			div.slush {
			   	padding-top      : 5px;
			   	padding-bottom   : 5px;
			   	background-color : #ffffff;
			   	border           : 1px solid #8b8b8b;
			}

			div.slush span.nameSpan {
			   	font-family  : Verdana;
			   	font-size    : 12px;
			   	display:block;
				padding: 2px 2px 2px 2px;
			}

			div.dragobject {
			   	background-color : #E0DDB5;
			   	color            : #5b5b5b;
			   	border           : 1px solid #5b5b5b;
			   	-moz-opacity     : 0.7;
			   	padding          : 1px 5px 1px 5px;
			}
			//background-color : #E0DDB5;
		</style>
	</head>
	<body>
		
		
		<h1>SlushBox control</h1>
		<p><b>You can double click on any name or just drag and drop</b></p><br>
		<table>
			<tr>
				<td valign="top">
					<div id="dragBox" style="display:inline;margin-left:8px;margin-bottom:8px;float:left">
						<span>Available Names</span>
						<div class="slush" id="left" style="width:250px;height:140px;overflow:auto">
					   	</div>
					   	<br><br>
					   	Selection : <input type="text" id="leftControlSelection">
					</div>
					
					<div id="dropBox" style="margin-left:8px;margin-bottom:8px;float:left">
					   	<span>Selected Names</span>
					   	<div class="slush" id="right" style="width:250px;height:140px;overflow:auto;">
					   	</div>
					   	<br><br>
					   	Selection : <input type="text" id="rightControlSelection">
					</div>
					
					<script>
					  	var data = {"items":[ 
					  				{"key":1, "value":"Arjun Kalura", "location":"rightControl"}, 
					  				{"key":2, "value":"Vivaan Kalura"},
					  				{"key":3, "value":"Preeti Grover"},
					  				{"key":4, "value":"John Smith"},
					  				{"key":5, "value":"Ross Parsay"},
					  				{"key":6, "value":"Scott Alison"},
					  				{"key":7, "value":"Smyara Brown"},
					  				{"key":8, "value":"Rebecca Swing"},
					  				{"key":9, "value":"George Peter"}
					  			]};
					  			
						slushBox = new mxAjax.SlushBox({
							leftControl: "left",
							rightControl: "right",
							leftControlSelection: "leftControlSelection",
							rightControlSelection: "rightControlSelection",
							cssClass: {"draggable":"dragobject"}
						});
					  	slushBox.loadData(data);
					</script>
				</td>
			</tr>
		</table>
		<script type="text/javascript" language="javascript">
		</script>
		
		
	</body>
</html>