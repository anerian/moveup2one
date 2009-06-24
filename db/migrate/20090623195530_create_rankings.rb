class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.integer  :list_id,    :null => false
      t.integer  :user_id,    :default => nil
      t.text     :ordinals,       :null => false
      t.timestamps
    end
    
    add_index :rankings, [:list_id, :user_id], :unique => true
  end

  def self.down
    drop_table :rankings
  end
end
