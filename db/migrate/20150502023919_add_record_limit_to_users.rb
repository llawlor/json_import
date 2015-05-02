class AddRecordLimitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :records_limit, :integer, default: 1000
  end
end
