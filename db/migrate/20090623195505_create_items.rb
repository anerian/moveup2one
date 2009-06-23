class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string   :title,                     :null => false
      t.text     :description
      t.integer  :list_id,                   :null => false
      t.float    :cached_average_rank
      t.float    :cached_standard_deviation
      t.timestamps
    end
    
    add_index :items, :list_id
  end

  def self.down
    drop_table :items
  end
end
