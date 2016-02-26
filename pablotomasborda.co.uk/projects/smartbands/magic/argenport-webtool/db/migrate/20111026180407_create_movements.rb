class CreateMovements < ActiveRecord::Migration
  def self.up
    create_table :movements do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :movements
  end
end
