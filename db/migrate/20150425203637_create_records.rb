class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.jsonb :json
      t.integer :user_id

      t.timestamps null: false
    end
    
    add_index :records, :json, using: :gin
  end
end
