<cfparam name="savingMessage" default="Saving...please wait" />
<cfparam name="queringIMDBMessage" default="Quering IMDB...please wait" />
<cfparam name="imdbLinkNotSavedMessage" default="IMDB link has not been saved" />

<cfset mxAjaxUrl = Application.RootPath & "mxajax/cf/mxAjaxFunctions.cfc" />
<cfset locationsRecord = viewstate.getvalue("LocationsRecord") />
<cfset keyString = "&ID=#urlEncodedFormat(locationsRecord.getID())#" />
<cfset returnUrl = viewstate.getvalue("returnUrl") />
<cfset commitEvent = viewstate.getvalue("myself") & viewstate.getValue("SaveLocationEvent") & keyString />

<cfset isNew = true />
<cfif (not isNumeric(locationsRecord.getID()) and len(locationsRecord.getID())) or (isNumeric(locationsRecord.getID()) and locationsRecord.getID())>
  <cfset isNew = false />
</cfif>

<cfoutput>
<div id="movieBanner">
<cfif isNew>
Add New Location
<cfelse>
#locationsRecord.getName()#
</cfif>
</div>
<br />
<form action="#commitEvent#" class="edit" id="locationForm" name="locationForm">
<fieldset>
	<input type="hidden" id="ID" name="ID" value="#locationsRecord.getID()#" />
	<div class="formfield">
		<label for="Name"><b>Name:</b></label>
		<div>
		<input type="text" class="input" maxlength="255" id="Name" name="Name" value="#locationsRecord.getName()#" />
		</div>
	</div>
	<div class="formfield">
		<label>&nbsp;</label>
		<span id="locationStatusMessage">#savingMessage#</span>
	</div>
	<div class="controls">
    <input type="submit" value="Save" />
    <input type="button" value="Cancel" onclick="mylightWindow.deactivate();" />
	</div>
</fieldset>
</form>
<script type="text/javascript">
function SaveData(e)
{
	$('statusMessage').update('#savingMessage#');
	$('statusMessage').show();
	var params = $('locationForm').serialize();

	$('locationForm').disable();
	new Ajax.Request(
		$('locationForm').action,
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
	$('locationStatusMessage').hide();
	mylightWindow.deactivate();
}

$('locationStatusMessage').hide();

//var elements = $A(Form.getElements('movieForm'));
var elements = $A($('locationForm').getElements());
//var elements = $$("input, textarea, select");

elements.each(function(element){
	if (element.type != "hidden")
		Event.observe(element, 'focus', function() {element.addClassName('selectedField');});
		Event.observe(element, 'blur', function() {element.removeClassName('selectedField');});
});

Event.observe('locationForm', 'submit', SaveData);
</script>
<script type="text/javascript" src="./js/frmMovies.js"></script>
</cfoutput>