class Account < ActiveRecord::Base
  has_one :link
  has_many :movements
  belongs_to :user, :autosave => true
 
  
end
