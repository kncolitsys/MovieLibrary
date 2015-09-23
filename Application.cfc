<!---
File:			application.cfc
Created on:		06.05.2007
Updated:		06.05.2007
Author:			Boyan Kostadinov (boyank@gmail.com)
Description:
				Sets "constant" variables and includes consistent header
--->
<cfcomponent output = "false">

<cfscript>
   this.name = "MovieLibrary";
   this.adminEmail = "";
   this.applicationTimeout = createTimeSpan(365,0,0,0);
   this.clientmanagement= "yes";
   this.loginstorage = "session" ;
   this.sessionmanagement = "yes";
   this.sessiontimeout = createTimeSpan(0,0,60,0);
   this.setClientCookies = "yes";
   this.setDomainCookies = "no";
   this.scriptProtect = "all";
   this.RootPath = GetDirectoryFromPath(cgi.path_info);
</cfscript>

<cffunction name="onApplicationStart" output="false">
	<!--- Set the application downtime to disabled --->
	<cfset Application.ApplicationDowntimeEnabled = false />

	<!--- Set the application name --->
	<cfset Application.Name = this.name />

	<!--- Set the application's start date --->
	<cfset Application.AppStarted = now() />

	<!--- Set the administartive email for the application --->
	<cfset Application.AdminEmail = this.adminEmail />

	<!--- Set the full url of the application --->
	<cfset Application.FullPath = lcase(rereplace(cgi.server_protocol, '/.*$', ''))
		   & '://' & cgi.http_host & this.RootPath>

	<cfset Application.RootPath = this.RootPath />
	<!--- Create the parent path by getting the directory from current script path,
	removing the last directory from it,
	replacing the first \ slashe with /
	and removing the last trailing slash --->
	<cfset Application.ParentPath = this.RootPath
	.replacefirst("([^\\\/]+[\\\/]){1}$", "")
	.replacefirst("\\", "/")
	.replaceall("\/$", "") />

	<!--- Set the images path of the application --->
	<cfset Application.Images = this.RootPath & "images">

	<!--- Store the session timeout in the application scope (converted to minutes) --->
	<cfset Application.SessionTimeout = this.sessiontimeout / 60 />
</cffunction>

<cffunction name="OnRequestStart" output="no">
	<cfset appDownPath = Application.RootPath & "index.cfm?event=ApplicationDown" />
	<cfset cgiPath = cgi.path_info & "?" & cgi.query_string />

	<cfif structKeyExists(url, "init")>
		<cfset structclear(Application) />
		<cfset structclear(Session) />

		<cfset onApplicationStart() />
	<cfelseif Application.ApplicationDowntimeEnabled
		and
		appDownPath neq cgiPath>
		<!--- Redirect to the application downtime page --->
		<cflocation url="#appDownPath#" addtoken="no" />
	</cfif>
</cffunction>

<cffunction name="onSessionStart" output="false">
	<!--- Set today's date --->
	<cfset Application.TodaysDate = "#dateformat(Now(), "m/dd/yy")#">
</cffunction>

<cffunction name="onApplicationEnd" returntype="void" output="false">
</cffunction>

</cfcomponent>