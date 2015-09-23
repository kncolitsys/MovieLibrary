<cfset nameStartsWith = viewstate.getvalue("NameStartsWith", "a") />

<cfset moviesEvent = viewstate.getvalue("myself") & "ListMoviesXml"
		& "&NameStartsWith=" & nameStartsWith />
<cfset duplicateMoviesEvent = viewstate.getvalue("myself") & "ListDuplicateMovies" />
<cfset dvdDuplicateMoviesEvent = viewstate.getvalue("myself") &
		"ListDuplicateMoviesByFormat&Format=DVD" />
<cfset pcDuplicateMoviesEvent = viewstate.getvalue("myself") &
		"ListDuplicateMoviesByFormat&Format=PC" />

<cfset editLocationEvent = viewstate.getValue("myself") & "EditLocation" />
<cfset editEvent = viewstate.getValue("myself") & viewstate.getValue("EditEvent") />
<cfset deleteEvent = viewstate.getValue("myself") & viewstate.getValue("DeleteEvent") />
<cfset selfLink = viewstate.getvalue("myself") & viewstate.getvalue("event") />
<cfset loadingMessage = "Loading movies starting with ""#ucase(nameStartsWith)#""..." />
<cfset alphabetList="0,1,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z">
<cfset currentEvent = viewstate.getvalue("myself") & viewstate.getvalue("event") & "&NameStartsWith=" & nameStartsWith />

<cfoutput>
<script type="text/javascript">
var dsMovies = new Spry.Data.XMLDataSet('#moviesEvent#', "movies/movie", {useCache: false});
</script>
<div id="breadcrumb">
<span id="moviesEventSpan"><a id="moviesEvent" href="##">Movies</a></span>
/
<span id="duplicateMoviesEventSpan"><a id="duplicateMoviesEvent" href="##">Duplicate Movies</a></span>
/
<span id="dvdDuplicateMoviesEventSpan"><a id="dvdDuplicateMoviesEvent" href="##">DVD Format Duplicate Movies</a></span>
/
<span id="pcDuplicateMoviesSpan"><a id="pcDuplicateMoviesEvent" href="##">PC Format Duplicate Movies</a></span>
/
<a href="#editEvent#" class="lWOn" params="lWWidth=600,lWHeight=400,lWContentType=page">Add New Movie</a>
/
<a href="#editLocationEvent#" class="lWOn" params="lWWidth=600,lWHeight=400,lWContentType=page">Add New Location</a>
</div>
<br />
<div id="movieBanner"></div>
<ul id="alphabetList">
<!--- Loop through the alphabet list --->
<cfloop from="1" to="#listlen(alphabetList)#" step=1 index="listPosition">
    <!--- Get the current letter from the list --->
    <cfset alpha = ucase(listgetat(alphabetList, listPosition))>

	<cfif nameStartsWith neq alpha>
	    <li id="startsWith_#alpha#">
		<a title="#alpha#" onclick="GetData('#alpha#');">#alpha#</a>
		</li>
	<cfelse>
	    <li id="startsWith_#alpha#" class="selectedLetter">#alpha#</li>
	</cfif>
</cfloop>
</ul>
<input type="hidden" id="previousLetter" name="previousLetter" />
<input type="hidden" id="previousLink" name="previousLink" />
<input type="hidden" id="returnUrl" name="returnUrl" />
<br /><br /><br />
<div spry:state="loading" id="statusMessage">#loadingMessage#</div>
<div spry:region="dsMovies" id="moviesDiv">
<table class="list">
	<tr>
		<th scope="col" onclick="dsMovies.sort('moviename');">Name</th>
		<th scope="col" onclick="dsMovies.sort('imdblink');">IMDB Link</th>
		<th scope="col" onclick="dsMovies.sort('numberofdiscs');">Number Of Discs</th>
		<th scope="col" onclick="dsMovies.sort('dateinserted');">Added On</th>
		<th scope="col" onclick="dsMovies.sort('formatname');">Format</th>
		<th scope="col" onclick="dsMovies.sort('locationname');">Location</th>
		<th scope="col">Action</th>
	</tr>
	<tr spry:repeat="dsMovies" spry:hover="myHoverClass">
		<td>{moviename}</td>
		<td>
		<span spry:choose="spry:choose">
			<span spry:when="'{imdblink}' != ''"><a href="{imdblink}">{imdblink}</a></span>
			<span spry:default="spry:default">&nbsp;</span>
		</span>
		</td>
		<td style="text-align: center">{numberofdiscs}</td>
		<td>{dateinserted}</td>
		<td>{formatname}</td>
		<td>{locationname}</td>
		<td>
		<a id="editMovie_{id}" href="#editEvent#&ID={id}" class="lWOn" params="lWWidth=600,lWHeight=400,lWContentType=page" onclick="return EditMovie('editMovie_{id}')">[E]</a>
		<a id="deleteMovie_{id}" href="#deleteEvent#&ID={id}" onclick="return DeleteMovie('{id}');">[X]</a>
		</td>
	</tr>
</table>
</div>
<script type="text/javascript" language="javascript">
function setNoticeVisibility(isVisible)
{
	var noteRegionStyle = document.getElementById('statusMessage').style;

	if (isVisible == true)
		noteRegionStyle.visibility = 'visible';
	else
		noteRegionStyle.visibility = 'hidden';
	
}//end function setNoticeVisibility

function setNote(str)
{
	var noteRegion = document.getElementById('statusMessage');
	noteRegion.innerHTML = str;
}

function EditMovie(elementID)
{
	mylightWindow.initializeWindow($(elementID));
	// Create a callback function to be used when the window is closed
	mylightWindow.options.onClosingCallFunction = OnClosingLightWindow;
	mylightWindow.activate(null, $(elementID))

	return false;
}

function DeleteMovie(movieID)
{
	if (confirm('Are you sure?')) {
		var params = 'ID=' + movieID;

		new Ajax.Request(
			'#deleteEvent#',
			{
			method: 'get',
			parameters: params,
			onComplete: OnClosingLightWindow,
			evalScript: true
			}
		);
	}

	return false;
}

function OnClosingLightWindow()
{
	GetData($('previousLetter').value);
}

function GetData(selectedLetter)
{
	var previousLetter = $('previousLetter').value;
	var previousNode = $('startsWith_' + previousLetter);
	var pageUrl = '#moviesEvent#'.replace(/NameStartsWith=(\w)/, "NameStartsWith=" + selectedLetter);

	$('moviesDiv').hide();

	var a = document.createElement('a');
	a.setAttribute('id', 'linkStartsWith_' + previousLetter);
	a.setAttribute('title', previousLetter);
	a.setAttribute('onclick', 'GetData("' + previousLetter + '");');
	$(a).update(previousLetter);
	$A(previousNode.childNodes).each(function(node) { previousNode.removeChild(node) })
	previousNode.appendChild(a);
	previousNode.removeClassName('selectedLetter');

	$('startsWith_' + selectedLetter).update(selectedLetter);
	$('startsWith_' + selectedLetter).addClassName('selectedLetter');
	setNote('#loadingMessage#'.replace(/"\w"/, '"' + selectedLetter + '"'));
	setNoticeVisibility(true);

	
	dsMovies.setURL(pageUrl);

	$('previousLetter').value = selectedLetter;
	$('returnUrl').value = $('returnUrl').value.replace(/NameStartsWith=(\w)/, "NameStartsWith=" + selectedLetter);

	dsMovies.loadData();
}

function LoadDataFromUrl(pageHeading, pageUrl)
{
	$('moviesDiv').hide();
	$('alphabetList').hide();

	$('movieBanner').update(pageHeading);
	$('movieBanner').show();

	setNote('Loading "' + pageHeading + '"...please wait');
	setNoticeVisibility(true);

	dsMovies.setURL(pageUrl);
	dsMovies.loadData();
}

var myObserver = new Object;
myObserver.onDataChanged = function(dataSet, notificationType)
{
	setNote('');
	setNoticeVisibility(false);
	$('moviesDiv').show();
};

Event.observe(window, 'load', function() {
	dsMovies.addObserver(myObserver);
	$('previousLetter').value = '#ucase(nameStartsWith)#';
	$('previousLink').value = 'Movies,moviesEvent,#currentEvent#';
	$('returnUrl').value = '#currentEvent#';
	$('movieBanner').hide();
});

Event.observe('duplicateMoviesEvent', 'click', function() {
	LoadDataFromUrl('Duplicate Movies', '#duplicateMoviesEvent#')
});
Event.observe('dvdDuplicateMoviesEvent', 'click', function() {
	LoadDataFromUrl('DVD Format Duplicate Movies', '#dvdDuplicateMoviesEvent#')
});
Event.observe('pcDuplicateMoviesEvent', 'click', function() {
	LoadDataFromUrl('PC Format Duplicate Movies', '#pcDuplicateMoviesEvent#')
});
Event.observe('moviesEvent', 'click', function() {
	$('movieBanner').hide();
	GetData('A');
	$('alphabetList').show();
});
</script>
</cfoutput>