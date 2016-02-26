class CreateUsersHasUsers < ActiveRecord::Migration
  def self.up
    create_table :users_has_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :users_has_users
  end
end
