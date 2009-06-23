class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.string   :title,                   :null => false
      t.integer  :user_id,                 :null => false
      t.text     :description
      t.integer  :items_count,             :default => 0
      t.integer  :comments_count,          :default => 0
      t.boolean  :is_private,              :default => false
      t.timestamps
    end
    
    add_index :lists, :user_id
  end

  def self.down
    drop_table :lists
  end
end
