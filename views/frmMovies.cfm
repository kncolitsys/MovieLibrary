<cfparam name="savingMessage" default="Saving...please wait" />
<cfparam name="queringIMDBMessage" default="Quering IMDB...please wait" />
<cfparam name="imdbLinkNotSavedMessage" default="IMDB link has not been saved" />

<cfset mxAjaxUrl = Application.RootPath & "mxajax/cf/mxAjaxFunctions.cfc" />
<cfset moviesRecord = viewstate.getvalue("MoviesRecord") />
<cfset keyString = "&ID=#urlEncodedFormat(moviesRecord.getID())#" />
<cfset returnUrl = viewstate.getvalue("returnUrl") />
<cfset commitEvent = viewstate.getvalue("myself") & viewstate.getValue("SaveMovieEvent") & keyString />
<cfset formatID = viewstate.getvalue("FormatID", 0) />
<cfset locationID = viewstate.getvalue("LocationID", 0) />

<cfset validation = viewstate.getValue("MoviesValidation", structNew()) />
	<cfset isNew = true />
<cfif (not isNumeric(MoviesRecord.getID()) and len(MoviesRecord.getID())) or (isNumeric(MoviesRecord.getID()) and MoviesRecord.getID())>
  <cfset isNew = false />
</cfif>

<cfoutput>
<div id="movieBanner">
<cfif isNew>
Add New Movie
<cfelse>
#MoviesRecord.getName()#
</cfif>
</div>
<br />
<form action="#commitEvent#" class="edit" id="movieForm" name="movieForm">
<fieldset>
	<input type="hidden" id="ID" name="ID" value="#MoviesRecord.getID()#" />
	<input type="hidden" id="IMDBLink" name="IMDBLink" value="" />
	<div class="formfield">
		<label for="FormatID" <cfif structKeyExists(validation, "Formats")>class="error"</cfif>><b>Format:</b> </label>
		<cfset valueQuery = viewstate.getValue("FormatsList") />
		<div>
		<cfset sourceValue = "" />
		<cftry>
		<cfif structKeyExists(MoviesRecord, "getFormatID")>
			<cfset sourceValue = MoviesRecord.getFormatID() />
		<cfelseif structKeyExists(MoviesRecord, "getParentFormatID")>
			<cfset sourceValue = MoviesRecord.getParentFormatID() />
		</cfif>
		<cfcatch />
		</cftry>
		<cfif isObject(sourceValue)>
			<cfset sourceValue = sourceValue.getID() />
		<cfelseif formatID neq "0">
			<cfset sourceValue = formatID />
		</cfif>
		<select name="FormatID" id="FormatID" >
		<cfloop query="valueQuery">
		<option value="#valueQuery.ID#" <cfif sourceValue eq valueQuery.ID>selected</cfif>>#valueQuery.Name#</option>
		</cfloop>
		</select>
		</div>
		<cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="Formats" validation="#validation#" />
	</div>
	<div class="formfield">
		<label for="LocationID" <cfif structKeyExists(validation, "Locations")>class="error"</cfif>><b>Location:</b> </label>
		<cfset valueQuery = viewstate.getValue("LocationsList") />
		<div>
		<cfset sourceValue = "" />
		<cftry>
			<cfif structKeyExists(MoviesRecord, "getLocationID")>
				<cfset sourceValue = MoviesRecord.getLocationID() />
			<cfelseif structKeyExists(MoviesRecord, "getParentLocationID")>
				<cfset sourceValue = MoviesRecord.getParentLocationID() />
			</cfif>
		<cfcatch />
		</cftry>
		<cfif isObject(sourceValue)>
			<cfset sourceValue = sourceValue.getID() />
		<cfelseif locationID neq "0">
			<cfset sourceValue = locationID />
		</cfif>
		<select name="LocationID" id="LocationID">
		<cfloop query="valueQuery">
		<option value="#valueQuery.ID#" <cfif sourceValue eq valueQuery.ID>selected</cfif>>#valueQuery.Name#</option>
		</cfloop>
		</select>
		</div>
		<cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="Locations" validation="#validation#" />
	</div>
	<div class="formfield">
		<label for="Name" <cfif structKeyExists(validation, "Name")>class="error"</cfif>><b>Name:</b></label>
		<div>
		<input type="text" class="input" maxlength="255" id="MovieName" name="MovieName" value="#MoviesRecord.getName()#" />
		</div>
		<cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="Name" validation="#validation#" />
	</div>
	<div class="formfield">
		<label for="IMDBLink" <cfif structKeyExists(validation, "IMDBLink")>class="error"</cfif>><b>IMDB Link:</b></label>
		<div>
		<input type="text" id="savedIMDBLink" name="savedIMDBLink" class="input" value="" size="50" maxlength="255" />
		<select id="googleIMDBLink" name="googleIMDBLink">
		<option value="#MoviesRecord.getIMDBLink()#">#MoviesRecord.getIMDBLink()#</option>
		</select>
		<br />
		<cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="IMDBLink" validation="#validation#" />
	</div>
	</div>
	<div class="formfield">
		<label>&nbsp;</label>
		<div>
		<a href="##" id="doIMDBLookup">IMDB Lookup</a>
		<a href="##" id="cancelIMDBLookup">Cancel IMDB Lookup</a>
		</div>
	</div>
	<div class="formfield">
		<label>&nbsp;</label>
		<div>
		<span id="imdbLinkNotSaved" class="error">IMDB link has not been saved</span>
		</div>
	</div>
	<div class="formfield">
		<label>&nbsp;</label>
		<span id="statusMessage">#savingMessage#</span>
	</div>
	<div class="controls">
    <input type="submit" value="Save" />
    <input type="button" value="Cancel" onclick="mylightWindow.deactivate();" />
	</div>
</fieldset>
</form>
<script type="text/javascript">
var didLookup = false;

function SaveData(e)
{
	$('statusMessage').update('#savingMessage#');
	$('statusMessage').show();
	var params = $('movieForm').serialize();

	$('movieForm').disable();
	new Ajax.Request(
		$('movieForm').action,
		{
		method: 'post',
		parameters: params,
		onComplete: ShowSavedResults,
		evalScript: true
		}
	);
	
	Event.stop(e);
}

function ShowSavedResults(response)
{
	var selectedLetter = $F('MovieName').substring(0, 1);
	mylightWindow.deactivate();
	GetData(selectedLetter);
}

function AfterModelPopulated(response, json)
{
	$('statusMessage').hide();
	$('imdbLinkNotSaved').show();

	$("googleIMDBLink").show();
	if (!$('IMDBLink').value.empty()) {
		$("cancelIMDBLookup").show();
	}
	$('IMDBLink').value = $F('googleIMDBLink');
	$("googleIMDBLink").update(json.calls[1].data.replace(/&sbquo;/g, ","));
	$("googleIMDBLink").enable();
}

function DoIMDBLookup()
{
	if (!$F('MovieName').empty()) {
		$('googleIMDBLink').disable();
		$('doIMDBLookup').hide();
		$('savedIMDBLink').hide();
		$('statusMessage').update('#queringIMDBMessage#');
		$('statusMessage').show();

		new mxAjax.Select({
			parser: new mxAjax.CFArrayToJSKeyValueParser(),
			executeOnLoad: true,
			target: "googleIMDBLink", 
			paramArgs: new mxAjax.Param("#mxAjaxUrl#",{param:"movieName={MovieName}", httpMethod:"get", cffunction:"IMDBLinkLookup"}),
			postFunction: AfterModelPopulated,
			source: "MovieName"
		});

		return false;
	}
}

Event.observe('cancelIMDBLookup', 'click', function() {
	if (!$('savedIMDBLink').value.empty()) {
		$("doIMDBLookup").show();
		$("savedIMDBLink").show();

		$("cancelIMDBLookup").hide();
		$("googleIMDBLink").hide();
		$('imdbLinkNotSaved').hide();
		
		$('IMDBLink').value = $("savedIMDBLink").value;
	}
});

$('IMDBLink').value = '#MoviesRecord.getIMDBLink()#';
$("cancelIMDBLookup").hide();
$('imdbLinkNotSaved').hide();
$('statusMessage').hide();
$('googleIMDBLink').hide();

if (!$('IMDBLink').value.empty())
{
	$('savedIMDBLink').value = $('IMDBLink').value;
	$('savedIMDBLink').show();
}
else {
	if (!$('MovieName').value.empty()) {
		DoIMDBLookup();
	}

	$('savedIMDBLink').hide();
}
//var elements = $A(Form.getElements('movieForm'));
var elements = $A($('movieForm').getElements());
//var elements = $$("input, textarea, select");

elements.each(function(element){
	if (element.type != "hidden")
		Event.observe(element, 'focus', function() {element.addClassName('selectedField');});
		Event.observe(element, 'blur', function() {element.removeClassName('selectedField');});
});

Event.observe('doIMDBLookup', 'click', DoIMDBLookup);
Event.observe('movieForm', 'submit', SaveData);
</script>
<script type="text/javascript" src="./js/frmMovies.js"></script>
</cfoutput>