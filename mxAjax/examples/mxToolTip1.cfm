<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Populating Drop down list with Coldfusion Array</title>
		<cfoutput>
		<script type='text/javascript' src='../core/js/prototype.js'></script>
		<script type='text/javascript' src='../core/js/mxAjax.js'></script>
		</cfoutput>
		<script language="javascript">
			var url = "<cfoutput>#ajaxUrl#</cfoutput>";
	
			function init() {
				/*
				t_tj = $("nm");
				i=0;
				j=8;
				tt_Show(
					t_tj,
					"tOoLtIp"+i+""+j,
					"yahoooo....");
				*/
			}
			addOnLoadEvent(function() {init();});
		</script>
		
	</head>
	<body>
		
		
		<h1>Using mxTooltip Component</h1>
		
		<a id="nm" "href="index.htm" onmouseover="return escape('Some text')">Homepage </a> 
		<br><br>
		<a href="index.htm" onmouseover="this.T_WIDTH=200;this.T_FONTCOLOR='#003399';return escape('Blablah')"> Homepage</a>
		<br><br> 
		
		
		
		
		<script type='text/javascript' src='../core/js/mxToolTip.js'></script>
		
	</body>
</html>
