class CreateUsersHasCompanies < ActiveRecord::Migration
  def self.up
    create_table :users_has_companies do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :users_has_companies
  end
end
