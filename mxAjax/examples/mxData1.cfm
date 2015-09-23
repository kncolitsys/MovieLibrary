<html>
	<head>
		<title>Returning Data from CF page</title>
		<cfoutput>
		<script type='text/javascript' src='../core/js/prototype.js'></script>
		<script type='text/javascript' src='../core/js/mxAjax.js'></script>
		<script type='text/javascript' src='../core/js/mxData.js'></script>
		</cfoutput>
		<script language="javascript">
			var url = "<cfoutput>#ajaxUrl#</cfoutput>";
			
			function init() {
				new mxAjax.Data({
					executeOnLoad:true,
					paramArgs: new mxAjax.Param(url,{param:"id=1", cffunction:"getContent"}),
					postFunction: handleData
				});
				
				function handleData(response) {
					alert(response);
				}
			}
			
			addOnLoadEvent(function() {init();});
		</script>
		
	</head>
	<body>
		
		
		<h1>Returning Data from CF page</h1>
		
		
	</body>
</html>