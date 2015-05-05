module RecordsHelper

  # add classes to keys and values
  def json_as_html(json)
    # opening html
    html = "<table class='table table-striped json-table'>"
    # for each key
    json.keys.each do |key|
      # add html for each hash and key/value
      html += "<tr><td class='json-text json-key'>#{key}</td><td class='json-text json-value'>#{json[key]}</td></tr>"
    end
    # closing html
    html += "</table>"
    # return the html
    return html
  end
  
end
