class Movement < ActiveRecord::Base
  has_many :links
  belongs_to :account
end
