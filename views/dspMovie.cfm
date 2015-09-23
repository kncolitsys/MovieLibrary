<cfset listEvent = viewstate.getValue("myself") & viewstate.getValue("xe.list")  />
<cfset commitEvent = viewstate.getValue("myself") & viewstate.getValue("xe.commit") & "&MovieId=" & urlEncodedFormat(viewstate.getValue("MoviesId")) />
<cfset MoviesRecord = viewstate.getValue("MoviesRecord") />
<cfset validation = viewstate.getValue("MoviesValidation", structNew()) />

<cfoutput>
<div id="breadcrumb"><a href="#listEvent#">Movies</a> / View Movie</div>
<br />
<cfform class="edit">
<fieldset>
	<div class="formfield">
	    <label for="Formats"><b>Format:</b></label>
		<div>#MoviesRecord.getFormats().getName()#</div>
	</div>
	<div class="formfield">
    	<label for="Locations"><b>Location:</b></label>
		<div>#MoviesRecord.getLocations().getName()#</div>
	</div>
	<div class="formfield">
    	<label for="Name"><b>Name:</b></label>
	    <span class="input">#MoviesRecord.getName()#</span>
	</div>
	<div class="formfield">
    	<label for="IMDBLink"><b>IMDB Link:</b></label>
	    <span class="input">#MoviesRecord.getIMDBLink()#</span>
	</div>
</fieldset>
</div>
</cfform>
</cfoutput>