<html>
	<head>
		<title>Using mxRotator</title>
		<cfoutput>
		<script type='text/javascript' src='../core/js/prototype.js'></script>
		<script type='text/javascript' src='../core/js/mxAjax.js'></script>
		<script type='text/javascript' src='../core/js/mxRotator.js'></script>
		<script type='text/javascript' src='../core/js/rico.js'></script>
		<script type='text/javascript' src='../core/js/ricoEffects.js'></script>
		<script type='text/javascript' src='../core/js/ricoUtil.js'></script>
		</cfoutput>
		<script language="javascript">
			var url = "<cfoutput>#ajaxUrl#</cfoutput>";
			
    		data = [   "/mxajax/core/images/products/camera.jpg"
    	               ,"/mxajax/core/images/products/laptop.jpg"
    	               ,"/mxajax/core/images/products/palm.jpg"
    	               ,"/mxajax/core/images/products/treo.jpg"
    	               ]
			
			var rotator = new mxAjax.Rotator({
				data: data,
				selectedData: 0,
				headerImageDimension: [100,100],
				bodyImageDimension: [50,50],
				source: "positionMe"
			});
			
			function init() {
				rotator.createRotator();
			}
			addOnLoadEvent(function() {init();});
		</script>
		
	    <link rel="stylesheet" type="text/css" href="/mxajax/css/container.css">
	</head>
	<body>
		
		
		<h1>mxRotator without content</h1>
		<br><br>
		
		<table>
			<tr>
				<td width="300" valign="top">
					<div id="positionMe" style="position:absolute;background-color:red;width:192px;height:202px;padding:0px">
						<div style="height:130px;text-align:center;padding-top:10px;padding-bottom:0px">
						</div>
						<div style="height:60px;padding:0px">
						</div>
					</div>
				</td>
			</tr>
		</table>
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
		
		
		
	</body>
</html>