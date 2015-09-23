<?php
	require_once "Json.php";
	class mxAjax
	{
		public static function init()
		{
			$json = new Services_JSON(SERVICES_JSON_LOOSE_TYPE);
			$dataPass = "";
			$mxAjaxRequest = "";
			$htmlresponse = false;
			
			if (isset($_GET["json"]))
			{ 
				if  ($_SERVER["REQUEST_METHOD"] === "GET") {
					$dataPass = $_GET;
				} else {
					$dataPass = $_POST;
				}
				$mxAjaxRequest = $json->decode($dataPass["mxAjaxParam"]);
			} else {
				$mxAjaxRequest = mxAjax::convertToJsonRequest();
			}
			
			$mxAjaxResponse = "";
			if ( isset($mxAjaxRequest["calls"])) {
				//multiple function call
				$mxAjaxResponse = array();
				foreach ($mxAjaxRequest["calls"] as $key => $call)
				{
					foreach ($call as $_key => $_value)
					{
						$functionName = $_key;
						$functionCall = "\$functionReturnData = " . $functionName . "(";
						$innCtr=0;
						foreach ($_value as $__key => $__value)
						{
							if ($__key != 'htmlresponse') {
								$innCtr++;
								if ($innCtr > 1) $functionCall .=  ",";
								if (is_string($__value)) {
									$functionCall .= "'" . $__value . "'";
								} else {
									$functionCall .= $__value;	
								}
							}
						}
						$functionCall = $functionCall . ");";
						eval ($functionCall);
						
						$callResponse = array();
						$callResponse["functionName"] = $functionName;
						$callResponse["data"] = $functionReturnData;
						$mxAjaxResponse["calls"][] = $callResponse;
					} 
				} 
			} else {
				//single function call
				$functionCall = "";
				foreach ($mxAjaxRequest as $_key => $_value)
				{
					$functionName = $_key;
					if (strtolower($functionName) !== "htmlresponse") {
						$functionCall = "\$functionReturnData = " . $functionName . "(";
						$params = array_keys($_value);
						$innCtr = 0;
						for ($ctr=0; $ctr < count($params); $ctr++) {
							if ( strtolower($params[$ctr]) != 'htmlresponse') {
								$innCtr++;
								if ($innCtr > 1) $functionCall .=  ",";
								$__value = $_value[$params[$ctr]];
								if (is_string($__value)) {
									$functionCall .= "'" . $__value . "'";
								} else {
									$functionCall .= $__value;	
								}
							}
						}
						$functionCall = $functionCall . ");";
					} else {
						$htmlresponse = $_value;
					}
				} 
				eval ($functionCall);
				$mxAjaxResponse = $functionReturnData;
			}
			if (!$htmlresponse) {
				$mxAjaxResponse = $json->encode($mxAjaxResponse);
			}
			echo trim($mxAjaxResponse);
			exit();
		}
		
		
		private static function convertToJsonRequest()
		{
			$dataPass = "";
			if  ($_SERVER["REQUEST_METHOD"] === "GET") {
				$dataPass = $_GET;
			} else {
				$dataPass = $_POST;
				//if ajax call was made directly using prototype lib. ie. using this syntax new Ajax.Updater('image', 'http://domain/demo.cfc?method=init&function=modelImage&model=10&htmlResponse=true')
				//prototype uses the http post, but we are interested in url data.
				if (count($dataPass) == 0)  $dataPass = $_GET;	
			}
			if ( isset( $dataPass["function"] ) )
			{
				$retData = array();
				$functionName = $dataPass["function"];
				unset ($dataPass["function"]);
				unset ($dataPass["method"]);
				unset ($dataPass["ajaxcallid"]);
				if (array_key_exists("portalrand", $dataPass)) {
					unset ($dataPass["portalrand"]);
				}
				if (array_key_exists("_", $dataPass)) {
					unset ($dataPass["_"]);
				}
				$retData[$functionName] = $dataPass;
				if ( isset($dataPass["htmlResponse"]) ) {
					$retData["htmlresponse"] = $dataPass["htmlResponse"];
				} else {
					$retData["htmlresponse"] = false;
				}
				return $retData;
			} else {
				throw new Exception("invalid mxAjax request");
			}
		}
	}
	
/*	
function makelookup($make)
{
	return "this is makelookup =>" . $make . " yes it is...<br>";
}

function makeDescription($make)
{
	return "this is makeDescription =>" . $make . " yes it is...<br>";
}	

function getContent($id) {
	return "get content <br>";
}
	
	$obj = new mxAjax();
	$obj->init();
*/	
//	
//http://localhost:8080/core/php/mxAjax.php?&5832_1162495988603&method=init&json=true&mxAjaxParam={%22calls%22:[{%22makelookup%22:{%22make%22:%22Nokia%22}},{%22makeDescription%22:{%22make%22:%22Nokia%22}}]}&_=
//http://localhost:8080/core/php/mxAjax.php?method=init&function=getContent&id=1&_=	
?>