class ProductOrders < ActiveRecord::Base
	set_table_name 'products_orders'
	has_one :order
	has_one :product
end
