#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
require File.join(root, "config", "environment")
require 'nokogiri'
require 'open-uri' 

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
	feed = Feed.find(:first, :conditions => {:status => 'active'}).order('last_parse ASC')
	if feed 
		feed.last_parse = Time.now
		feed.save

		category_key =  DatafeedKey.find(:first, :conditions => {:feed_id => feed.id, :field_id => Field.find_by_name('category')})
		producthash_key = DatafeedKey.find(:first, :conditions => {:feed_id => feed.id, :field_id => Field.find_by_name('unique hash')})

		if producthash_key
			if feed.feed_path == nil
				if !feed.url.blank?
					open_uri_fetched = open(feed.url)
					doc = Nokogiri::XML(open(open_uri_fetched))
				else
					feed.status = 'NoFile'
					feed.save
				end
			else
				f = File.open(File.join('../../',feed.feed_path))
					doc = Nokogiri::XML(f)
				f.close
			end

			if category_key 

				foreign_categories = Array.new
				doc.xpath(feed.xml_path+'/'+category_key.name).each do |node|
				    foreign_categories << node.text
				end

				if foreign_categories.count > 0
					foreign_categories.uniq.each do |category|
						if !ForeignCategory.find(:first, :conditions => {:feed_id => feed.id, :name => category})	
						  newkey = ForeignCategory.new
						  newkey.feed_id = feed.id
						  newkey.name = category
						  newkey.save
						end
					end
				end

			end	

			products = Array.new
			doc.xpath(feed.xml_path).each do |product|
			    records = DatafeedKey.where('field_id <> ?', Field.where('name' => 'dont use').first)
		       	productdata = Hash.new
				records.each do |record|
					if record.field.name == 'category'
						productdata[:category_id] = ForeignCategory.find_by_name(product.xpath(record.name).text).id
					else
						productdata[record.field.product_column_name.to_sym] = product.xpath(record.name).text
					end
				end
				productdata[:feed_id] = feed.id
				productdata[:user_id] = feed.user_id
				products << productdata
			end


			existing_product_hashes = Product.find(:all, :conditions => {:feed_id => feed.id}, :select => "id").map{|p| p.id}
			
			products.each do |product|
				existing_product = Product.find(:last, :conditions => {:feed_id => feed.id, :unique_hash => product[:unique_hash]})
				if existing_product
					existing_product.update_attributes(product)
					existing_product_hashes.delete(existing_product.id)
				else
					Product.create(product).save
				end
			end
			#Product.delete_all(:id => existing_product_hashes)
			Product.update_all({:status => 'inactive'}, {:id => existing_product_hashes})
		end	
	end
  	Rails.logger.auto_flushing = true
  	Rails.logger.info "This daemon is still running at #{Time.now}.\n"
  	sleep 60
end