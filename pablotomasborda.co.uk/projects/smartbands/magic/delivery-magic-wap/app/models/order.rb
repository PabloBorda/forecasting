class Order < ActiveRecord::Base
  belongs_to :company
  has_one :address
  belongs_to :store
end
