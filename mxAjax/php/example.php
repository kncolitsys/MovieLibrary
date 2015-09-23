<?php
	require_once "ExampleDbConnection.php";
	require_once "mxAjax.php";

	function makeAndDescription($make)
	{
		$retData = array();
		$retData["lookup"] = makeLookup($make);
		$retData["description"] = makeDescription($make);
   		return $retData;
	}	

	function makeLookup($make)
	{
		$db = new ExampleDbConnection();
		$rs = $db->getPhoneModel($make, "");
		$retData = array();
		foreach ($rs as $row) {
			$retData[] = $row["model"] . "," . $row["name"];
   		}
   		return $retData;
	}	
	
	function makeDescription($make)
	{
		$db = new ExampleDbConnection();
		$rs = $db->getPhoneMakeDescription($make);
		foreach ($rs as $row) {
			return $row["description"];
   		}
   		return "n/a";
	}
	
	function modelImage($model)
	{
		$db = new ExampleDbConnection();
		$rs = $db->getPhoneModel("", $model);
		$retData = array();
		foreach ($rs as $row) {
			return "<img src='http://www.indiankey.com/cfajax/examples/" . $row["image"] . "' border='0'/>";
   		}
   		return "n/a";
	}
	
	function getContent($id)
	{
		$db = new ExampleDbConnection();
		$rs = $db->getContent($id);
		$retData = "";
		foreach ($rs as $row) {
			$retData = "<h3>" . $row["title"] . "</h3><p>" . $row["content"] . "</p><br><br>" . date('r');	
			return $retData;
   		}
   		return "n/a";
	}
	
	function getRandomQuote()
	{
		$db = new ExampleDbConnection();
		$rs = $db->getRandomQuote();
		$retData = "";
		foreach ($rs as $row) {
			$retData = "<br>" . $row["quote"] . "</br><i>" . $row["author"] . " - " . $row["moreinfo"] . "</i><br><br>" . date('r');	
			return $retData;
   		}
   		return "n/a";
	}

	function getRandomFact()
	{
		$db = new ExampleDbConnection();
		$rs = $db->getRandomFact();
		$retData = "";
		foreach ($rs as $row) {
			$retData = "<h3><a href=\"" . $row["link"] . "\" target=\"_new\">" . $row["title"] . "</a></h3><p>" . $row["detail"] . "</p><br><br>" . date('r');
			return $retData;
   		}
   		return "n/a";
	}

	function getStateList($searchCharacter)
	{
		$db = new ExampleDbConnection();
		$rs = $db->getState($searchCharacter);
		$retData = "";
		
		//have to do this workaround to make resultset similar to CFQuery resultset
		//ideally i would have used a different parser on client side, and simply returned a php array
		//but i want to keep the same frontend example for both CF and php backend
		
		$codeArray = array();
		$valueArray = array();
		foreach ($rs as $row) {
			$codeArray[] = $row["Code"];	
			$valueArray[] = $row["Name"];	
   		}
   		
   		$retData = array();
   		$retData["RECORDCOUNT"] = count($codeArray);
   		$retData["COLUMNLIST"] = "CODE,VALUE";
   		$retData["DATA"] = array("CODE" => $codeArray, "VALUE" => $valueArray);
   		return $retData;
	}
	
	function getCopyrightContent()
	{
		$date = date('r'); 
		ob_start( );
		print <<<END
			<html>
			<head>
				<title>Example Terms and Conditions</title>
				<style type="text/css">
					@import 'data/DOMinclude.css';
				</style>
			</head>
			<body>
				<h1>Dynamic Content</h1>
				<b>All of this content is comming from Server side CF Page</b>
				<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Suspendisse
				  vulputate felis ut est. Vivamus congue. Nullam consequat. Etiam elit
				  ipsum, pulvinar in, commodo sed, malesuada et, wisi. Maecenas nunc odio,
				  interdum et, mollis eget, egestas quis, enim. Vestibulum augue leo,
				</p>
			</body>
			</html>
			<br><br><br> $date;
END;
		$retData = ob_get_contents( );
		ob_end_clean( );
		return $retData;
	}
	
	
	function setRating($rating)
	{
		return true;
	}
	
	
	function getMessageTickerData()
	{
		$db = new ExampleDbConnection();
		$rs = $db->getAllQuote();
		$retData = array();
		foreach ($rs as $row) {
			$retData[] = $row["quote"];	
   		}
   		return $retData;
	}	
	
	mxAjax::init();
?>