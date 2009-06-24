class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :user_id,         :null => false
      t.integer :subscription_id, :null => false
      t.decimal :amount,          :precision => 10, :scale => 2, :default => 0.0
      t.string  :transaction_id
      t.timestamps
    end
    
    add_index :payments, :user_id
    add_index :payments, :subscription_id
  end

  def self.down
    drop_table :payments
  end
end