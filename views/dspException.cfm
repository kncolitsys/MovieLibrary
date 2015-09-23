<!--- Test comment --->
<cfset exception = viewstate.getValue("exception") />
<!--- Get the tag context --->
<cfset tagCtxArr = exception.TagContext />

<!--- Get the first template and line number from the tag context --->
<cfset exceptionTemplate = tagCtxArr[1]['template'] />
<cfset exceptionLine = tagCtxArr[1]['line'] />
<cfoutput>
<!--- If the current host is not the localhost --->
<cfif cgi.http_host neq 'localhost'>
<div id="errorPage">
	<!--- Display sarcastic message to poor user --->
	<h2>Bug Spray Ready! Set! Spray!</h2>
	<h3>
	or in other words the application goofed...you should never see this page.
	</h3>
	<p>
	We are very sorry, but a technical problem prevents us from
	showing you what you are looking for. Unfortunately, these things
	happen from time to time, even though we have only the most
	top-notch people on our technical staff. Perhaps all of
	our programmers need a raise, or more vacation time. As always,
	there is also the very real possibility that SPACE ALIENS
	(or our rivals at Miramax Studios) have sabotaged our website.
	</p>
	<p>
	That said, we will naturally try to correct this problem
	as soon as we possibly can. Please try again shortly.
	</p>
	<p>
	The webmaster (<a href="mailto: #Application.AdminEmail#">#Application.AdminEmail#</a>) has been notified.</a>
	</p>
</div>
</cfif>

<!--- Create the text for the exception information --->
<cfsavecontent variable="exceptionDebugInfo">
<br />
=======================================================================================
<br />
<strong>Date and Time: </strong>#DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm:ss tt')#
<br />
<strong>URL: </strong><a href="http://#cgi.http_host##cgi.script_name#?#cgi.query_string#">
http://#cgi.http_host##cgi.script_name#?#cgi.query_string#</a>
<br />
<strong>File: </strong>#exceptionTemplate#
<br />
<strong>Line Number: </strong>#exceptionLine#
<br />
<strong>Error Message: </strong>#exception.message#
<br />
<strong>Tag Context: </strong>
<br />
<cfloop index="i" from="1" to="#ArrayLen(tagCtxArr)#">
	<cfset tagCtx = tagCtxArr[i] />
	#tagCtx['template']# (#tagCtx['line']#)<br />
</cfloop>
<br />
<strong>Query String: </strong>#cgi.query_string#
<br />
<strong>Path Info: </strong>#cgi.path_info#
<br />
<strong>Referer: </strong>#cgi.http_referer#
<br />
<strong>IP: </strong>#cgi.remote_addr#
<br />
<strong>Request Method: </strong>#cgi.request_method#
<ul>
	<li><strong>User Location: </strong>#cgi.remote_addr#
	<li><strong>User's Browser: </strong>#cgi.http_user_agent#
	<li><strong>Page Refered: </strong>#cgi.http_referer#
</ul>
<br />
<cfif cgi.request_method is "post">
<strong>Form Scope: </strong><cfdump var="#form#" label="Form">
<br />
</cfif>
<strong>URL Scope: </strong><cfdump var="#url#" label="Url">
<br />
<strong>Session Scope: </strong><cfdump var="#session#" label="Session">
<br />
<strong>CGI Scope: </strong><cfdump var="#cgi#" label="CGI">
<br />
<strong>Request: </strong><cfdump var="#Request#" label="Request">
<br />
=======================================================================================
</cfsavecontent>

<!--- If the code is not running on the localhost, send an email message to site administrator
(or whatever address provided to Application.AdminEmail) --->
<cfif Application.AdminEmail neq '' and cgi.http_host neq 'localhost'>
	<cfmail to="#Application.AdminEmail#" from="bkostadinov@indium.com"
			subject="Error in File #GetFileFromPath(exceptionTemplate)#" type="html">
	#exceptionDebugInfo#
	</cfmail>
<cfelse>
<!--- Else, display the exception info on the screen --->
<strong>Send to: </strong>#Application.AdminEmail#
<br />
<strong>Subject: </strong>Error in File #GetFileFromPath(exceptionTemplate)#
#exceptionDebugInfo#
</cfif>
</cfoutput>