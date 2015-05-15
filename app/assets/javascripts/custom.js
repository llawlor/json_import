// when the document is ready
$(document).on('ready page:load', function() {
  // make some preformatted text look nicer
  prettyPrint();
  
  // allow flash notices to be dismissed
  if ($(".flash").length > 0) {
    $(".flash").on("click", function() {
      $(this).hide("slow");
    });
    // hide flash automatically after 15 seconds
    setTimeout(function() {
      if ($(".flash").length > 0) {
        $(".flash").hide("slow");
      }
    }, 15000);
  }
  
  // only set json on this page
  if ($('#json_show_page').length > 0) {
    setJsonShowPage();
  }

});

// when the default json button is clicked
$(document).on('click', '#default_json', function() {
  if ($('#record_json').val() === '') {
    $('#record_json').val('{\n  "title": "",\n  "text": ""\n}');
  }
});

// clicks outside of the table
$(document).on('click', function() {
  if ($('#json_show_page').length > 0) {
    hideJsonInputs();
  }
});
  
// set javascript for json show page
function setJsonShowPage() {
  // hide the text area
  $('#record_json_form_group').css('display', 'none');
  
  // intercept the save button click
  $('#save_button').on('click', function() {
    // set the textarea to the proper value
    setFormJson();
    // submit the form
    $('#json_form')[0].submit();
    // override default button behavior
    return false;
  });
  
  // hide all inputs initially
  $('.json-input').hide();
  
  // set behavior of json inputs
  setJsonInputListeners();
}

// sets the value for the json in the form
function setFormJson() {
  // opening json string
  var json_string = '{';
  
  // for each json input
  $('.json-input').each(function() {
    // add the quoted string
    json_string += '"' + $(this).val().replace(/"/g, '\\"') + '"';
    // add a colon if this is a json key
    if ($(this).hasClass('json-key')) { json_string += ': '; }
    // else add a comma
    else { json_string += ', '; }
  });
  
  // remove the last 2 character: comma space
  if (json_string.length > 2) {
    json_string = json_string.slice(0, -2);
  }
  
  // closing json string
  json_string += '}';

  // replace line endings
  json_string = json_string.replace(/\n/g, '\\n');

  // set the form element
  $('#record_json').val(json_string);
}

// set behavior of json inputs
function setJsonInputListeners() {
  // when a cell is clicked
  $('.json-hash').on('click', function() {
    // set the input
    setJsonInput($(this).find('.json-text'));
    // prevent the document click from firing and reverting the inputs
    event.stopPropagation();
  });
}

// hides json inputs and shows the input text
function hideJsonInputs() {
  // for each json input
  $('.json-input').each(function() {
    // set the text correctly
    $(this).siblings('.json-text').text($(this).val());
    // hide this
    $(this).hide();
  });
  
  // show the text
  $('.json-text').show();
}

// sets an input
function setJsonInput($element) {
  // revert json inputs back to text
  hideJsonInputs();
  // show the input
  $element.siblings('.json-input').show();
  // hide the text, must be hidden after the siblings are shown or else android keyboard doesn't appear
  $element.hide();
}
