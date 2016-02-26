class User < ActiveRecord::Base
   has_many :users_has_users, :foreign_key => "user_id", :class_name => "User"
   has_many :users_has_users, :foreign_key => "relatives_id", :class_name => "User"
end
