class UsersHasUser < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :relatives, :class_name => "User", :foreign_key => "relatives_id"
end
