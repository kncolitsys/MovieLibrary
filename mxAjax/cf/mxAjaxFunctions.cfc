<!----
 * http://www.indiankey.com/mxajax/
 *
 * @author Arjun Kalura (arjun.kalura@gmail.com)
 * @version 0.1, July 8th 2006
---->
<cfcomponent extends="mxAjax">
<cffunction name="IMDBLinkLookup">
	<cfargument name="movieName" required="yes" type="string">
	<cfargument name="searchPageUrl" required="no" default="http://www.google.com/search" />

	<cfset var linkNamesArray = arraynew(1) />
	<cfset var linkArray = arraynew(1) />
	<cfset var returnArray = arraynew(1) />
	<cfset var matchInfo = 0 />

	<!--- Grab the google search results --->
	<cfhttp
	url="#searchPageUrl#?hl=en&lr=&q=imdb+#urlencodedformat(movieName)#&btnG=Search"
	useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; FDM)"
	result="objGoogleGrab"
	method="get"
	resolveurl="true"
	/>
	<!---http://blog.stevenlevithan.com/regular-expressions/rematch-coldfusion/--->
	<cfset matchInfo = reMatch('href="(http://us.imdb.com/title\?\w+)".[^>]*>(.*?)<\s*/\s*a\s*>', objGoogleGrab.FileContent, 1, "sub", true) />

	<cfif isarray(matchInfo[2]) and isarray(matchInfo[3])>
		<cfloop from="1" to="#arraylen(matchInfo[2])#" index="i">
			<cfset name = matchInfo[3][i].match.replaceall("<(.|\n)*?>", "") />
			<cfset name = name.replaceall("(&.*?;)", "") />
			<cfset name = name.replaceall(",", "&sbquo;") />
			<cfset name = rereplacenocase(name, "imdb(:|\s?-)?\s?", "") />

			<cfset link = matchInfo[2][i].match />

			<cfset currentLink = structnew() />
			<cfset currentLink.name = name />
			<cfset currentLink.url = link />

			<cfset ArrayAppend(linkNamesArray, name)>
			<cfset ArrayAppend(linkArray, currentLink)>
		</cfloop>
	</cfif>
	
	<cfset matchInfo = reMatch('href="(http://www.imdb.com/title/\w+/)".[^>]*>(.*?)<\s*/\s*a\s*>', objGoogleGrab.FileContent, 1, "sub", true) />

	<cfif isarray(matchInfo[2]) and isarray(matchInfo[3])>
		<cfloop from="1" to="#arraylen(matchInfo[2])#" index="i">
			<cfset name = matchInfo[3][i].match.replaceall("<(.|\n)*?>", "") />
			<cfset name = name.replaceall("(&.*?;)", "") />
			<cfset name = name.replaceall(",", "&sbquo;") />
			<cfset name = rereplacenocase(name, "imdb(:|\s?-)?\s?", "") />

			<cfset link = matchInfo[2][i].match />

			<cfset currentLink = structnew() />
			<cfset currentLink.name = name />
			<cfset currentLink.url = link />

			<cfset ArrayAppend(linkNamesArray, name)>
			<cfset ArrayAppend(linkArray, currentLink)>
		</cfloop>
	</cfif>

	<cfset arraysort(linkNamesArray, "textnocase", "asc") />
	<cfloop from="1" to="#arraylen(linkNamesArray)#" index="i">
		<cfloop from="1" to="#arraylen(linkArray)#" index="k">
			<cfif linkArray[k].name eq linkNamesArray[i]>
				<cfset ArrayAppend(returnArray, "#linkArray[k].url#,#linkArray[k].name# - #linkArray[k].url#") />
			</cfif>
		</cfloop>
	</cfloop>

	<cfreturn returnArray />
</cffunction>

<cffunction name="ReMatch" access="public" output="false" returntype="array">
	<cfargument name="regex" type="string" required="yes" />
	<cfargument name="string" type="string" required="yes" />
	<cfargument name="start" type="string" required="no" default="1" />
	<cfargument name="scope" type="string" required="no" default="ONE" />
	<cfargument name="returnLenPos" type="boolean" required="no" default="false" />
	<cfargument name="caseSensitive" type="boolean" required="no" default="false" />
	<cfset var results = ArrayNew(1) />
	<cfset var info = "" />
	<cfset var pos = arguments.start />
	<cfset var i = 1 />
	<cfset var t = 1 />
	
	<cfif arguments.scope eq "SUB">
		<cfset results = ArrayNew(2) />
	</cfif>
	
	<!--- leading condition --->
	<cfif arguments.caseSensitive>
		<cfset match = ReFind(arguments.regex, arguments.string, pos, true) />
	<cfelse>
		<cfset match = ReFindNoCase(arguments.regex, arguments.string, pos, true) />
	</cfif>

	<cfloop condition="match.pos[1] neq 0">	
		<cfif arguments.scope is "ONE" or arguments.scope is "ALL">
			<cfset t = 1 />
		<cfelse>
			<cfset t = ArrayLen(match.pos) />
		</cfif>
		<cfloop from="1" to="#t#" index="i">
			<cfif match.len[i]>
				<cfif arguments.returnLenPos eq true>
					<cfset info = StructNew() />
					<cfset info.match = Mid(arguments.string, match.pos[i], match.len[i]) />
					<cfset info.len = match.len[i] />
					<cfset info.pos = match.pos[i] />
				<cfelse>
					<cfset info = Mid(arguments.string, match.pos[i], match.len[i]) />
				</cfif>
			<cfelse>
				<cfset info = "" />
			</cfif>
			
			<cfif arguments.scope is "SUB">
				<cfset ArrayAppend( results[i], info ) />
			<cfelse>
				<cfset ArrayAppend( results, info ) />
			</cfif>
		</cfloop>

		<cfif arguments.scope is "ONE">
			<cfset match.pos[1] = 0 />
		<cfelse>
			<cfset pos = match.pos[1] + match.len[1] />
			<cfif arguments.caseSensitive>
				<cfset match = ReFind(arguments.regex, arguments.string, pos, true) />
			<cfelse>
				<cfset match = ReFindNoCase(arguments.regex, arguments.string, pos, true) />
			</cfif>
		</cfif>

	</cfloop>
	
	<cfreturn results />
</cffunction>

	<cffunction name="makeAndDescription">
		<cfargument name="make" required="yes" type="string">
		<cfset retData = StructNew()>
		<cfset retData.lookup = makeLookup(arguments.make)>
		<cfset retData.description = makeDescription(arguments.make)>
		<cfreturn retData>
	</cffunction>

	<cffunction name="makeLookup">
		<cfargument name="make" required="yes" type="string">
		<cfset modelArray = ArrayNew(1)>
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT * FROM phoneModel WHERE make = '#arguments.make#'
		</cfquery>
		<cfloop query="qryData">
			<cfset ArrayAppend(modelArray, "#qryData.model#,#qryData.name#")>
		</cfloop>
		<cfreturn modelArray>
	</cffunction>
	
	<cffunction name="makeDescription">
		<cfargument name="make" required="yes" type="string">
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT * FROM phoneMake WHERE make = '#arguments.make#'
		</cfquery>
		<cfreturn qryData.description>
	</cffunction>

	<cffunction name="modelImage">
		<cfargument name="model" required="yes" type="string">
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT * FROM phoneModel WHERE model = '#arguments.model#'
		</cfquery>
		<cfreturn "<img src='http://www.indiankey.com/cfajax/examples/" & qryData.image & "' border='0'/>">
	</cffunction>
	
	<cffunction name="getRandomQuote">
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT * FROM quote WHERE id = #RandRange(1, 21, "SHA1PRNG")#
		</cfquery>
		<cfsavecontent variable="out">
			<cfoutput>
			<br>#qryData.quote#<br><br>
			<i>#qryData.author# - #qryData.moreinfo#</i>
			<br><br>
			#now()#
			</cfoutput>
		</cfsavecontent>
		<cfreturn out>
	</cffunction>
	
	<cffunction name="getRandomFact">
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT * FROM facts WHERE id = #RandRange(1, 12, "SHA1PRNG")#
		</cfquery>
		<cfsavecontent variable="out">
			<cfoutput>
			<h3><a href="#qryData.link#" target="_new">#qryData.title#</a></h3>
			<p>#qryData.detail#</p><br><br>
			#now()#
			</cfoutput>
		</cfsavecontent>
		<cfreturn out>
	</cffunction>
	
	<cffunction name="getContent">
		<cfargument name="id" type="numeric">
		
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT * FROM content WHERE id = #arguments.id#
		</cfquery>
		<cfsavecontent variable="out">
			<cfoutput>
			<h3>#qryData.title#</h3>
			<p>#qryData.content#</p><br><br>
			#now()#
			</cfoutput>
		</cfsavecontent>
		<cfreturn out>
	</cffunction>
	
	<cffunction name="getStateList" access="remote">
		<cfargument name="searchCharacter" required="yes" type="string" default="W"> 
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT Code AS [KEY], Name as [VALUE] from state WHERE [search] like '#lcase(urlDecode(searchCharacter))#%'
		</cfquery>
		<cfreturn qryData>
	</cffunction>
	
	<cffunction name="getCopyrightContent">
		<cfsavecontent variable="out"><cfoutput>
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
			<br><br><br>
			#now()#</cfoutput>
		</cfsavecontent>
		<cfreturn out>
	</cffunction>
	
	<cffunction name="setRating">
		<cfargument name="rating" required="yes">
		<cfset retData = true>
		<!--- save the information in database --->
		<cfreturn retData>
	</cffunction>

	<cffunction name="getMessageTickerData">
		<cfset retData = ArrayNew(1)>
	
		<cfquery datasource="#request.mxAjaxDS#" name="qryData">
			SELECT * FROM quote
		</cfquery>
		<cfloop query="qryData">
			<cfset ArrayAppend(retData, qryData.quote)>
		</cfloop>
	
		<cfreturn retData>
	</cffunction>
	
	
	<cffunction name="getCollect">
		<cfsavecontent variable="out">
			<cfoutput>
				some content..
				<cfoutput>#now()#</cfoutput>
			</cfoutput>
		</cfsavecontent>
		<cfreturn out>
	</cffunction>
	
</cfcomponent>