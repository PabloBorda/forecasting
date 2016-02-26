require 'json'
require 'net/http'
require 'set'
require 'app/helpers/application_helper.rb'
require 'cgi'

include ApplicationHelper

class WapController < ApplicationController
	def wap
		@company = params["companyid"]
		session["companyid"] = @company
	end

	def confirm

		@street = purify_address(params["street"])
		@number = params["number"]
		@depto = params["depto"]
		@phone = params["phone"]
		@company = session["companyid"]

		@my_url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' + CGI::escape(@street + " " + @number) + '&sensor=false'
		puts "======================" + @my_url
		uri = URI.parse @my_url
		@res = JSON.parse(Net::HTTP.get_response(uri).body)

		#Show the addresses but only from the countries that have stores
		@possible_countries = Set.new []
		@possible_provinces = Set.new []
		@possible_cities = Set.new []
		@possible_locations = Set.new []
		(Store.find_all_by_companies_id(@company)).each {
		|l|
			addrid = l.addresses_id
			addr = Address.find_by_id(addrid).address
			addr_parts = addr.split ','
			country = addr_parts.last
			province = addr_parts[addr_parts.size-2]
			city = addr_parts[addr_parts.size-3]
			@possible_countries.add country
			@possible_provinces.add province
			@possible_cities.add city
		}

		@res["results"].each{
		|addrs|
			current_address = addrs["formatted_address"].to_s
			current_addr_parts = current_address.split(',')

			if @possible_countries.include?(current_addr_parts.last) and (@possible_provinces.include? current_addr_parts[current_addr_parts.size-2] and @possible_cities.include? current_addr_parts[current_addr_parts.size-3]) and current_addr_parts.first.include?(@number)
				@possible_locations << addrs["formatted_address"].to_s
			end
		}
		if @possible_locations.size == 0
			@possible_cities.each { |c|
				c1 = CGI::escape(c.to_s)

				@my_url1 = 'http://maps.googleapis.com/maps/api/geocode/json?address=' +CGI::escape( @street + " " + @number + "," + c1) + '&sensor=false'
				puts "=================" + @my_url1
				uri = URI.parse @my_url1

				@res1 = JSON.parse(Net::HTTP.get_response(uri).body)
				@res1["results"].each{
				|addrs|
					current_address = addrs["formatted_address"].to_s
					current_addr_parts = current_address.split(',')

					if @possible_countries.include?(current_addr_parts.last) and (@possible_provinces.include? current_addr_parts[current_addr_parts.size-2] and @possible_cities.include? current_addr_parts[current_addr_parts.size-3]) and current_addr_parts.first.include?(@number)
						@possible_locations << addrs["formatted_address"].to_s
					end
				}
			}

		end

		@products = Product.find_all_by_companies_id(@company)

	#@stores = Store.find_all_by_companies_id(@company)
	#@stores.each {
	#	|s|
	#		puts "Coordinates are " + s.lat.to_s + "," + s.lng.to_s

	#}

	end

	def order_product
		@street = params["onestreet"]
		sl = ClosestStoreLocator.new

		if (not @street.nil?)

			@street = purify_address(params["onestreet"])
			@number = params["number"]
			@my_url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' + CGI::escape(@street) + '&sensor=false'

			uri = URI.parse @my_url
			@res = JSON.parse(Net::HTTP.get_response(uri).body)

			session["lat"] = @res["results"][0]["geometry"]["location"]["lat"].to_s
			session["lng"] = @res["results"][0]["geometry"]["location"]["lng"].to_s
			cs = sl.find_closest_store(session["lat"],session["lng"],session["companyid"])

			# Insert order into database

			order_addr = Address.new
			order_addr.lat = session["lat"]
			order_addr.lng = session["lng"]
			order_addr.address = @street
			order_addr.save

			my_order = Order.new
			my_order.companies_id = session["companyid"]
			my_order.timestamp = Time.now.utc.iso8601.gsub('-', '').gsub(':', '')
			my_order.phone = params["phone"]
			my_order.depto = params["depto"]
			my_order.amount = params["amount"]
			my_order.addresses_id = order_addr.id
			my_order.stores_id = cs
			my_order.save

			products = Product.find_all_by_companies_id(session["companyid"])
			products_str_for_message = ""
			products.each { |p|
				if (params[p.name.to_s.delete(" ")]!="")
					products_str_for_message = products_str_for_message + "\n" + products_str_for_message + p.name.to_s + ": " + params[p.name.to_s.delete(" ")]
					ordered_product_id = Product.find_by_name(p.name.to_s).id
					porder = ProductOrders.new
					porder.amount = params[p.name.to_s.delete(" ")]
				porder.products_id = ordered_product_id
				porder.orders_id = my_order.id
				porder.save
				end
			}

			session["cs"] = cs

			ja = JabberAdviser.new('delivery-magic@74.207.234.92','p2t3t4l5c6')
			puts "=======================store" + session["companyid"] + "-" + cs + "@74.207.234.92"
			text_to_send = "Address: " + @street + "\nNumber: " + @number + "\nDepto: " + my_order.depto + products_str_for_message + "\nPhone: " + my_order.phone + "\nAmount: " + my_order.amount.to_s
			ja.advise("store" + session["companyid"] + "-" + cs + "@74.207.234.92",text_to_send)

		end
	end

end
