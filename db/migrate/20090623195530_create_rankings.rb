class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.integer  :user_id,                   :null => false
      t.integer  :item_id,                   :null => false
      t.integer  :ordinal,                   :null => false
      t.timestamps
    end
    
    add_index :rankings, [:item_id, :user_id], :unique => true
  end

  def self.down
    drop_table :rankings
  end
end
