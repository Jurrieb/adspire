require './config/boot'
require './config/environment'
require 'clockwork'
include Clockwork
require 'nokogiri'
require 'open-uri' 

RECORDS = Hash.new

every(48.seconds, 'Startup Feeds') {

	feed = Feed.find(:first, :conditions => {:status => 'created'}, :order => "created_at") 

	if feed
		if feed.feed_path == nil
			if !feed.url.blank?
				open_uri_fetched = open(feed.url)
				doc = Nokogiri::XML(open(open_uri_fetched))
			else
				feed.status = 'NoFile'
				feed.save
			end
		else
			f = File.open(feed.feed_path)
				doc = Nokogiri::XML(f)
			f.close
		end

		product_value = 0
	    product_path = nil

	    fetch_node_name(doc.xpath("./*").first)

	    RECORDS.each do |record|
	      if product_value < record[1]['count']
	        product_value = record[1]['count']
	        product_path  = record[1]['path']+'/'+record[0]
	      end
	    end

	    feed.xml_path = product_path
	    feed.save

		foreign_keys = Array.new
			doc.xpath(feed.xml_path+"/*").each do |node|
		    foreign_keys << node.name
		end

		foreign_keys.uniq.each do |key|
			if !DatafeedKey.find(:first, :conditions => {:feed_id => feed.id,:name => key})
				newkey = DatafeedKey.new
				newkey.feed_id = feed.id
				newkey.name = key
				newkey.save
			end
		end
		feed.status = 'user_fields'
		feed.save
	end
}

every(123.seconds, 'parse products'){
	
	feed = Feed.find(:first, :conditions => {:status => 'active'}, :order => "last_parse") 
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
				f = File.open(feed.feed_path)
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

		else
			feed.status = 'user_fields'
			feed.save
		end
	end
}

def fetch_node_name(node, depth = 0)
	sub_nodes = node.xpath("./*")
	if sub_nodes.length > 1
		if RECORDS[node.name].blank?
		  RECORDS[node.name] = Hash.new
		  RECORDS[node.name]['count'] = 1
		  RECORDS[node.name]['path'] = node.parent.path()
		else 
		  RECORDS[node.name]['count'] += 1
		end
	end
	sub_nodes.map { |n| fetch_node_name(n, depth+1) } if sub_nodes.length > 0
end