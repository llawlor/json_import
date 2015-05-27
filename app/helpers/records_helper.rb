module RecordsHelper

  # convert line endings correctly
  def fix_input_lines(value)
    value.class == String ? value.gsub("\\n", "\n") : value.to_s
  end

  # convert line endings correctly for html
  def fix_html_lines(value)
    value.class == String ? value.gsub("\\n", "<br>").gsub("\n", "<br>") : value.to_s
  end
  
  # add classes to keys and values
  def json_as_html(json)
    # opening table html
    html = "<table class='table table-striped json-table col-sm-12 col-xs-12'>"
    # for each key
    json.keys.each do |key|
      # add opening row and cell html
      html += "<tr><td class='json-hash json-key col-sm-2 col-xs-4'>";
      # add html for the key text
      html += "<span class='json-text'>#{key}</span>";
      # add html for the key input
      html += "<input type='text' class='json-input json-key form-control' value='#{key}'>";
      # add html for the cell
      html += "</td><td class='json-hash json-value col-sm-10 col-xs-8'>";
      # add html for the value text
      html += "<span class='json-text'>#{fix_html_lines(json[key])}</span>";
      # add html for the value textarea
      html += "<textarea class='json-input json-value form-control' rows='8'>#{fix_input_lines(json[key])}</textarea>";
      # add closing cell and row html
      html += "</td></tr>"
    end
    # closing table html
    html += "</table>"
    # return the html
    return html
  end
  
end
