class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :id
      t.string :title
      t.string :link
      t.integer :sold
      t.integer :maxsoldday
      t.integer :leastsoldday
      t.timestamp :updated
      t.float :localcost
      t.float :chinacost
      t.date :maxsolddate
      t.date :minsolddate
      t.string :currency

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
