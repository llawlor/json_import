// when the document is ready
$(document).on('ready page:load', function() {
  // fix the json
  formatJSON();
});

// fix any json records for display
function formatJSON() {
  // if #record_json exists
  if ($('#record_json').length > 0 && $("#record_json").text().length > 0) {
    // get the json object
    var json = $.parseJSON($("#record_json").text());
    // pretty print it
    json = JSON.stringify(json, null, 2);
    // add it back to the div
    $("#record_json").html(json);
  }
  
  // if #record_json_html exists
  if ($('#record_json_html').length > 0 && $("#record_json_html").text().length > 0) {
    // allow the json to be edited
    $('#record_json_html')[0].contentEditable = true;
    // get the json object
    var json = $.parseJSON($("#record_json_html").text());
    // pretty print it
    json = JSON.stringify(json, null, 2);
    // add it back to the div
    $("#record_json_html").html(json);
  }
}
