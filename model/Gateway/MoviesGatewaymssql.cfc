<cfcomponent hint="I am the mssql custom Gateway object for the Movies object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="MoviesGateway" >

<cffunction name="GetMovies" access="public" output="false" returntype="xml">
	<cfargument name="orderBy" type="string" required="no" default="m.Name" />
	<cfargument name="orderDirection" type="string" required="no" default="asc" />
	<cfargument name="nameStartsWith" type="string" required="no" default="a" />

	<cfstoredproc datasource="#_getConfig().getDsn()#"
	procedure="dbo.GetMovies">
		<cfif arguments.nameStartsWith neq "">
			<cfprocparam
			cfsqltype="cf_sql_varchar"
			dbvarname="nameStartsWith" type="in" value="#arguments.nameStartsWith#" />
		</cfif>

		<cfprocparam
			cfsqltype="cf_sql_varchar"
			dbvarname="orderBy" type="in" value="#arguments.orderBy#" />

		<cfprocparam
			cfsqltype="cf_sql_varchar"
			dbvarname="orderDirection" type="in" value="#arguments.orderDirection#" />

		<cfprocresult name="moviesList" resultset="1" />
	</cfstoredproc>

	<cfreturn xmlParse(queryToXML(moviesList, "movies", "movie")) />
</cffunction>

<cffunction name="GetDuplicateMovies" access="public" output="false" returntype="xml">
	<cfargument name="orderBy" type="string" required="no" default="DateInserted" />
	<cfargument name="orderDirection" type="string" required="no" default="desc" />

	<cfset var moviesList = querynew("") />
	<cfset var sortedMoviesList = querynew("") />

	<cfif arguments.orderBy eq "">
		<cfset arguments.orderBy = "MovieName" />
	</cfif>

	<cfif arguments.orderDirection eq "">
		<cfset arguments.orderDirection = "asc" />
	</cfif>

	<cfstoredproc datasource="#_getConfig().getDsn()#"
	procedure="dbo.GetDuplicateMovies">
		<cfprocresult name="moviesList" resultset="1" />
	</cfstoredproc>

	<cfif moviesList.recordcount gt 0>
		<cfquery name="sortedMoviesList" dbtype="query">
		select		*
		from		moviesList
		order by	#arguments.orderBy# #arguments.orderDirection#
		</cfquery>
	</cfif>

	<cfreturn xmlParse(queryToXML(sortedMoviesList, "movies", "movie")) />
</cffunction>

<cffunction name="GetDuplicateMoviesByFormat" access="public" output="false" returntype="xml">
	<cfargument name="formatName" type="string" required="yes" />
	<cfargument name="orderBy" type="string" required="no" default="DateInserted" />
	<cfargument name="orderDirection" type="string" required="no" default="desc" />

	<cfset var moviesList = querynew("") />
	<cfset var sortedMoviesList = querynew("") />

	<cfif arguments.orderBy eq "">
		<cfset arguments.orderBy = "MovieName" />
	</cfif>

	<cfif arguments.orderDirection eq "">
		<cfset arguments.orderDirection = "asc" />
	</cfif>

	<cfstoredproc datasource="#_getConfig().getDsn()#"
	procedure="dbo.GetDuplicateMoviesByFormat">
		<cfprocparam cfsqltype="cf_sql_varchar"
		null="no" type="in" value="#arguments.formatName#" />

		<cfprocresult name="moviesList" resultset="1" />
	</cfstoredproc>

	<cfif moviesList.recordcount gt 0>
		<cfquery name="sortedMoviesList" dbtype="query">
		select		*
		from		moviesList
		order by	#arguments.orderBy# #arguments.orderDirection#
		</cfquery>
	</cfif>

	<cfreturn xmlParse(queryToXML(sortedMoviesList, "movies", "movie")) />
</cffunction>

<cffunction name="queryToXML" returntype="string" access="private" output="false" hint="Converts a query to XML">
	<cfargument name="data" type="query" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfargument name="cDataCols" type="string" required="false" default="">
	
	<cfset var s = createObject('java','java.lang.StringBuffer').init("<?xml version=""1.0"" encoding=""UTF-8""?>")>
	<cfset var col = "">
	<cfset var columns = arguments.data.columnlist>
	<cfset var txt = "">

	<cfset s.append("<#arguments.rootelement#>")>
	
	<cfloop query="arguments.data">
		<cfset s.append("<#arguments.itemelement#>")>

		<cfloop index="col" list="#columns#">
			<cfset txt = arguments.data[col][currentRow]>

			<cfif isSimpleValue(txt)>
				<cfif listFindNoCase(arguments.cDataCols, col)>
					<cfset txt = "<![CDATA[" & txt & "]]" & ">">
				<cfelse>
					<cfset txt = xmlFormat(txt)>
				</cfif>
			<cfelse>
				<cfset txt = "&nbsp;">
			</cfif>

			<cfset s.append("<#lcase(col)#>#txt#</#lcase(col)#>")>
		</cfloop>
		
		<cfset s.append("</#arguments.itemelement#>")>	
	</cfloop>
	
	<cfset s.append("</#arguments.rootelement#>")>
	
	<cfreturn s.toString()>
</cffunction>

</cfcomponent>