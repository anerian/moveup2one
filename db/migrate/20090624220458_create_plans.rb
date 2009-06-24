class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string     :name
      t.decimal    :amount, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end