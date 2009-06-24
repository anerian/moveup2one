class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.decimal  :amount, :precision => 10, :scale => 2
      t.datetime :next_renewal_at
      t.string   :card_number
      t.string   :card_expiration
      t.integer  :plan_id
      t.integer  :user_id
      t.integer  :renewal_period, :default => 1
      t.string   :billing_id
      t.timestamps
    end
    
    add_index :subscriptions, :user_id
  end

  def self.down
    drop_table :subscriptions
  end
end