class AddJsonKeysToUsers < ActiveRecord::Migration
  def change
    add_column :users, :json_keys, :text
  end
end
