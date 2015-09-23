<cfset viewEvent = viewstate.getValue("myself") & viewstate.getValue("xe.view") />
<cfset editEvent = viewstate.getValue("myself") & viewstate.getValue("xe.edit") />
<cfset deleteEvent = viewstate.getValue("myself") & viewstate.getValue("xe.delete") />
<cfset moviesList = viewstate.getValue("moviesList") />
<cfset selfLink = viewstate.getvalue("myself") & viewstate.getvalue("event") />
<cfset orderDirection = viewstate.getvalue("orderDirection", "desc") />
<cfset nameStartsWith = viewstate.getvalue("NameStartsWith", "a") />

<script type="text/javascript" src="./js/spry/xpath.js"></script>
<script type="text/javascript" src="./js/spry/SpryData.js"></script>
<script type="text/javascript">
//var dsSpecials = new Spry.Data.XMLDataSet("http://localhost/movies/movies.xml", "specials/menu_item");
var dsMovies = new Spry.Data.XMLDataSet("index.cfm?Event=ListMoviesXml", "movies/movie");
</script>
<cfset alphabetList="0,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z">
<cfoutput>
<div id="breadcrumb">
Movies
/
<a href="index.cfm?Event=ListDuplicateMovies">Duplicate Movies</a>
/
<a href="index.cfm?Event=ListDuplicateMoviesByFormat&FormatID=1">DVD Format Duplicate Movies</a>
/
<a href="index.cfm?Event=ListDuplicateMoviesByFormat&FormatID=2">PC Format Duplicate Movies</a>
/
<a href="#editEvent#">Add New Movie</a>
</div>
<br />
<ul id="alphabetList">
<!--- Loop through the alphabet list --->
<cfloop from="1" to="#listlen(alphabetList)#" step=1 index="listPosition">
    <!--- Get the current letter in the alphabet --->
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
<br /><br /><br />
<div spry:state="loading" id="statusMessage">Loading...</div>
<div spry:region="dsMovies" id="moviesDiv">
<table class="list">
	<tr>
		<th scope="col" onclick="dsMovies.sort('moviename');">Name</th>
		<th scope="col" onclick="dsMovies.sort('imdblink');">IMDB Link</th>
		<th scope="col" onclick="dsMovies.sort('numberofdiscs');">Number Of Discs</th>
		<th scope="col" onclick="dsMovies.sort('dateinserted');">Inserted</th>
		<th scope="col" onclick="dsMovies.sort('formatname');">Format</th>
		<th scope="col" onclick="dsMovies.sort('locationname');">Location</th>
	</tr>
	<tr spry:repeat="dsMovies">
		<td>{moviename}</td>
		<td>{imdblink}</td>
		<td>{numberofdiscs}</td>
		<td>{dateinserted}</td>
		<td>{formatname}</td>
		<td>{locationname}</td>
	</tr>
</table>
</div>
<script type="text/javascript" language="javascript">
function setNoticeVisibility(isVisible)
{
	var noteRegionStyle = document.getElementById('statusMessage').style;

	if ( isVisible == true )
		noteRegionStyle.visibility = 'visible';
	else
		noteRegionStyle.visibility = 'hidden';
	
}//end function setNoticeVisibility

function setNote(str)
{
	var noteRegion = document.getElementById('statusMessage');
	noteRegion.innerHTML = str;
}

function GetData(selectedLetter)
{
	var previousLetter = $('previousLetter').value;
	var previousNode = $('startsWith_' + previousLetter);

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
	setNote('Loading movies starting with "' + selectedLetter + '"...');
	setNoticeVisibility(true);
	dsMovies.setURL("index.cfm?event=ListMoviesXml&NameStartsWith=" + selectedLetter);

	$('previousLetter').value = selectedLetter;

	dsMovies.loadData();
}
var myObserver = new Object;

myObserver.onDataChanged = function(dataSet, notificationType)
{
   setNote('');
   setNoticeVisibility(false);
};

Event.observe(window, 'load', function() {
	dsMovies.addObserver(myObserver);
	$('previousLetter').value = '#ucase(nameStartsWith)#';
});
</script>
</cfoutput>