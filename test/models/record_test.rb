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

require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
