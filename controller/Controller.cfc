<cfcomponent displayname="Controller" extends="ModelGlue.unity.controller.Controller" output="false">

<cfset variables.moviesGateway = 0 />

<cffunction name="GetMovies" access="public" returntype="void" output="false">
 	<cfargument name="event" type="ModelGlue.core.event">

	<cfset var orderBy = arguments.event.getvalue("orderBy", "m.Name") />
	<cfset var orderDirection = arguments.event.getvalue("orderDirection", "asc") />
	<cfset var nameStartsWith = arguments.event.getvalue("nameStartsWith", "a") />

	<cfset var moviesList = 0 />

	<!---Get the movies list from the custom gateway function --->
	<cfset moviesList = variables.moviesGateway.GetMovies(orderBy, orderDirection, nameStartsWith) />

	<cfset arguments.event.setvalue("moviesList", moviesList) />
</cffunction>

<cffunction name="GetDuplicateMovies" access="public" returntype="void" output="false">
 	<cfargument name="event" type="ModelGlue.core.event">

	<cfset var orderBy = arguments.event.getvalue("orderBy", "MovieName") />
	<cfset var orderDirection = arguments.event.getvalue("orderDirection", "asc") />
	<cfset var nameStartsWith = arguments.event.getvalue("nameStartsWith", "a") />

	<cfset var moviesList = 0 />

	<!---Get the movies list from the custom gateway function --->
	<cfset moviesList = variables.moviesGateway.GetDuplicateMovies(orderBy, orderDirection) />

	<cfset arguments.event.setvalue("moviesList", moviesList) />
</cffunction>

<cffunction name="GetDuplicateMoviesByFormat" access="public" returntype="void" output="false">
 	<cfargument name="event" type="ModelGlue.core.event">

	<cfset var formatName = arguments.event.getvalue("Format") />
	<cfset var orderBy = arguments.event.getvalue("orderBy", "MovieName") />
	<cfset var orderDirection = arguments.event.getvalue("orderDirection", "asc") />

	<cfset var moviesList = 0 />

	<!---Get the movies list from the custom gateway function --->
	<cfset moviesList = variables.moviesGateway.GetDuplicateMoviesByFormat(formatName,orderBy, orderDirection) />

	<cfset arguments.event.setvalue("moviesList", moviesList) />
</cffunction>


<cffunction name="PrepareMovieForm" access="public" returntype="void" output="false">
 	<cfargument name="event" type="any">
	<cfset var fixedName = arguments.event.getvalue("Name", "") />

	<cfif fixedName neq "">
		<!--- Move the "The" to the end of the title --->
		<cfset fixedName = fixedName.replaceall("^The\s(.*)", "$1, The") />
	</cfif>

	<cfset arguments.event.setValue("Name", fixedName) />	
</cffunction>

<cffunction name="PrepareMovieInfo" access="public" returntype="void" output="false">
 	<cfargument name="event" type="any">
	<cfset var fixedName = arguments.event.getvalue("MovieName", "") />
	<cfset var lowerCaseWords = ('of,the,an,and,for,to,in,with,a') />

	<cfif fixedName neq "">
		<!--- Move the "The" to the end of the title --->
		<cfset fixedName = fixedName.replaceall("^The\s(.*)", "$1, The") />
		<cfset fixedName = fixedName.replaceall("^A\s(.*)", "$1, A") />
		<cfset fixedName = fixedName.replaceall("^An\s(.*)", "$1, An") />

		<!---<cfloop list="#lowerCaseWords#" index="i">
			<cfset arguments.event.trace("Word", i) />

			<cfif refind("^#i#", fixedName) eq 0 or refind("#i#$", fixedName) eq 0>
				<cfset arguments.event.trace("Found Word", i) />
				<cfset fixedName = fixedName.replace(fixedName, "#i#", "#i#") />
			</cfif>
		</cfloop> --->
	</cfif>

	<cfset arguments.event.setValue("Name", fixedName) />	
</cffunction>

<cffunction name="Init" access="Public" returntype="Controller" output="false" hint="">
	<cfargument name="ModelGlue">

	<cfscript>
	super.Init(arguments.ModelGlue);
	//variables.appConfig = getModelGlue().getBean("applicationConfiguration", true);
	variables.reactor = getModelGlue().getOrmService();
	variables.moviesGateway = reactor.createGateway("Movies");
	</cfscript>

	<cfreturn this />
</cffunction>

<cffunction name="onRequestStart" access="public" returntype="void" output="false">
 	<cfargument name="event" type="any">
</cffunction>

<cffunction name="onQueueComplete" access="public" returntype="void" output="false">
	<cfargument name="event" type="any">
</cffunction>

<cffunction name="onRequestEnd" access="public" returntype="void" output="false">
	<cfargument name="event" type="any">
</cffunction>

</cfcomponent>