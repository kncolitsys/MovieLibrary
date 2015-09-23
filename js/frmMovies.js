/*
var firstElement = '';
var formElements;
var currentElement = '';
var currentElementIndex = 0
var highlightElement;

Event.observe(
	window,
	'load',
	function(e) {
		// Get the form elements
		formElements = Form.getElements('movieForm');
		// Find the first element on the form
		firstElement = formElements.find(function(element) {
			return element.type != 'hidden' && !element.disabled &&
			['input', 'select', 'textarea'].include(element.tagName.toLowerCase());
		});

		if (highlightElement != 'undefined') {
			Field.focus(highlightElement);
			currentElement = highlightElement;
		}
		else {
			// Focus on the first element on the form		
			Field.focus(firstElement);
			highlightElement = firstElement;

			// Set the current element and current element index to the first element
			currentElement = firstElement;
			currentElementIndex = formElements.indexOf(firstElement);
		}

		// 'Highlight' the first element
		Element.classNames(highlightElement).add('selectedField');
	}
);

Event.observe(document, 'keyup', processKeys);
Event.observe(document, 'click', processKeys);

function processKeys(evt) {
	// Get the element that triggered the event
	var htmlElement = Event.element(evt);

	// If this is indeed an html element
	if (htmlElement.id != '') {
		if (currentElement != '') {
			if (formElements[currentElementIndex].type == 'checkbox') {
				Element.classNames(currentElement.parentNode).remove('selectedField');
			}
			else {
				// Remove the 'Highlight' from the current element
				Element.classNames(currentElement).remove('selectedField');
			}
			//if (t != '') {Element.remove("test")};
		}

		// Get the index of the element as it falls in the form elements array
		currentElementIndex = formElements.indexOf(htmlElement);
		if (currentElementIndex != -1) {
			// Also get the actual form element
			currentElement = formElements[currentElementIndex];	

			if (formElements[currentElementIndex].type == 'checkbox') {
				Element.classNames(currentElement.parentNode).add('selectedField');
			}
			else {
				// 'Highlight' the form element
				Element.classNames(currentElement).add('selectedField');
			}
		}
	}
}

/*Event.observe(
	'movieForm',
	'submit',
	function(e) {
		//if (CheckForEnterKey(e)) {
			var tempVar = $F('Name');
			tempVar = tempVar.capitalize();

			$('Name').value = tempVar;
		//}
	}
);

function CheckForEnterKey(e)
{
	var characterCode;
	var characterCode = e.keyCode;

	//if generated character code is equal to ascii 13 (if enter key)
	if (characterCode == Event.KEY_RETURN) {
		return true;
	}
	else {
		return false;
	}
}
*/