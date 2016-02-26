class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :types_id
      t.integer :amount
      t.integer :products_id
      t.string :address
      t.integer :users_id
      t.integer :sites_id
      t.string :track
      t.string :carriers_id
      t.integer :status_id
      t.integer :days
      t.float :declared
      t.float :tax
      t.boolean :experiment

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
