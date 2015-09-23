<cfoutput>
<html>
<head>
	<title>Movie Library</title>
	<link rel="stylesheet" type="text/css" href="css/stylesheet.css" media="screen" />
	<link rel="stylesheet" href="#Application.RootPath#css/lightWindow.css" type="text/css" media="screen" />
	<script type="text/javascript" src="#Application.RootPath#js/prototype.js"></script>
	<script type="text/javascript" src="#Application.RootPath#js/scriptaculous.js?load=effects"></script>
	<!--- <script type="text/javascript" src="#Application.RootPath#js/string.js"></script> --->
	<script type="text/javascript" src="#Application.RootPath#js/spry/xpath.js"></script>
	<script type="text/javascript" src="#Application.RootPath#js/spry/SpryData.js"></script>
	<script type="text/javascript" src="#Application.RootPath#js/lightWindow.js"></script>
	<script type="text/javascript" src="#Application.RootPath#js/mxAjax/mxAjax.js"></script>
	<script type="text/javascript" src="#Application.RootPath#js/mxAjax/mxSelect.js"></script>
</head>
<body>
<div>
	<div id="banner">Movie Library</div>
	<div>
		<div>
		#viewcollection.getView("body")#
		</div>
	</div>
	<div id="footer">
	</div>
</div>
</body>
</html>
</cfoutput>