# == Schema Information
#
# Table name: records
#
#  id         :integer          not null, primary key
#  json       :jsonb
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Record < ActiveRecord::Base
  belongs_to :user
  
  validate :json_format
  
  # pagination variables
  cattr_reader :per_page
  @@per_page = 15
  
  # output the json in a format that can be rendered via HTML <pre>
  def json_formatted
    begin
      JSON.pretty_generate(self.json).gsub("\\\\n", "\n").gsub("\\n", "\n").gsub("\n\n", "\n")
    rescue
    end
  end
  
  # get the json keys, and add it to the user account
  def update_user_json_keys!
    return if self.json.blank?
    # for each of this records keys
    self.json.keys.each do |key|
      # add the key if it doesn't exist
      self.user.json_keys.push(key) if !self.user.json_keys.include?(key)
    end

    # save the user keys
    self.user.save
  end
    
  protected

    def json_format
      errors[:base] << "Document is not in JSON format" if json.blank? || self.json.class != Hash
    end
  

end
