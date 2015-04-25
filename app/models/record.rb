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
end
