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
  
  validates_presence_of :json
  
  # pagination variables
  cattr_reader :per_page
  @@per_page = 15
  
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
  
end
