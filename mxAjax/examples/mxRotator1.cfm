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
			
    		data = [   "/mxajax/core/images/products/cd1.jpg"
    	               ,"/mxajax/core/images/products/cd2.jpg"
    	               ,"/mxajax/core/images/products/cd3.jpg"
    	               ,"/mxajax/core/images/products/cd4.jpg"
    	               ]
			
			var rotator = new mxAjax.Rotator({
				data: data,
				selectedData: 0,
				headerImageDimension: [160,160],
				bodyImageDimension: [80,80],
				source: "positionMe",
				postFunction: handleData
			});
			
			function handleData(selectedIndex) 
			{
				//console.log("its here =>" + selectedIndex);
				$("content").innerHTML = $("content" + selectedIndex).innerHTML;
			}
			
			function init() {
				rotator.createRotator();
			}
			addOnLoadEvent(function() {init();});
		</script>
		
	    <link rel="stylesheet" type="text/css" href="/mxajax/css/container.css">
	
	</head>
	<body>
		
		
		<h1>Using mxRotator</h1>
		<br><br>
		
		<table>
			<tr>
				<td width="300" valign="top">
					<div id="positionMe" style="position:absolute;background-color:red;width:282px;height:282px;padding:0px">
						<div style="height:180px;text-align:center;padding-top:10px;padding-bottom:0px">
						</div>
						<div style="height:100px;padding:0px">
						</div>
					</div>
				</td>
				<td>
					<div id="content" style="">
					</div>
					<div id="content0" style="display:none">
						<b><a href="http://www.amazon.com/Baby-One-More-Time-ENHANCED/dp/B00000G1IL/ref=m_art_pr_1/102-6273530-2988129" target="_blank">Baby One More Time</a></b><br/><br/>
						<b>Original Release Date:</b> January 12, 1999<br/>
						<b>ASIN:</b> B00000G1IL<br/>
						<ul>
							<li>. . . .Baby One More Time</li>
							<li>(You Drive Me) Crazy</li>
							<li>Sometimes </li>
							<li>Soda Pop</li>
							<li>Born To Make You Happy</li>
							<li>From The Bottom Of My Broken Heart</li>
							<li>I Will Be There</li>
							<li>I Will Still Love You</li>
							<li>Thinkin' About You</li>
						</ul>
					</div>
					<div id="content1" style="display:none">
						<b><a href="http://www.amazon.com/Christina-Aguilera/dp/B00000JY9M/ref=m_art_pr_3/102-6273530-2988129" target="_blank">Christina Aguilera</a></b><br/><br/>
						<b>Original Release Date:</b> August 24, 1999<br/>
						<b>ASIN:</b> B00000JY9M<br/>
						<ul>
							<li>Genie In A Bottle</li>
							<li>What A Girl Wants</li>
							<li>I Turn To You</li>
							<li>So Emotional</li>
							<li>Come On Over (All I Want Is You)</li>
							<li>Reflection </li>
							<li>Love For All Seasons</li>
							<li>Somebody's Somebody</li>
							<li>When You Put Your Hands On Me</li>
						</ul>
					</div>
					<div id="content2" style="display:none">
						<b><a href="http://www.amazon.com/No-Strings-Attached-NSYNC/dp/B00004NRPZ/ref=m_art_pr_1/102-6273530-2988129" target="_blank">No Strings Attached</a></b><br/><br/>
						<b>Original Release Date:</b> March 21, 2000<br/>
						<b>ASIN:</b> B00004NRPZ<br/>
						<ul>
							<li>Bye Bye Bye</li>
							<li>It's Gonna Be Me</li>
							<li>Space Cowboy (Yippie-Yi-Yay)</li>
							<li>Just Got Paidl</li>
							<li>It Makes Me Ill</li>
							<li>This I Promise You </li>
							<li>No Strings Attached</li>
							<li>Digital Get Down</li>
							<li>Bringin' Da Noise</li>
						</ul>
					</div>
					<div id="content3" style="display:none">
						<b><a href="http://www.amazon.com/This-Skin-Jessica-Simpson/dp/B0000AKCLI/ref=m_art_pr_4/102-6273530-2988129" target="_blank">In This Skin</a></b><br/><br/>
						<b>Original Release Date:</b> August 19, 2003<br/>
						<b>ASIN:</b> B0000AKCLI<br/>
						<ul>
							<li>Sweetest Sin</li>
							<li>With You</li>
							<li>My Way Home</li>
							<li>I Have Loved You</li>
							<li>Forbidden Fruit</li>
							<li>Everyday See You</li>
							<li>Underneath </li>
							<li>You Don't Have To Let Go</li>
							<li>Loving You</li>
						</ul>
					</div>
				</td>
			</tr>
		</table>
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
		
		
		
	</body>
</html>