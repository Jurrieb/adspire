class Feed < ActiveRecord::Base

	require 'nokogiri'
	require 'open-uri' 

	has_many :products
	has_many :feednodes, :autosave => true
	has_many :foreign_categories, :dependent => :delete_all

	attr_accessible :name, :url, :xml_path, :feed_path, :interval_in_seconds, :last_parse, :method_type, :filename, :feednodes_attributes
	accepts_nested_attributes_for :feednodes, :allow_destroy => true
	has_attached_file :filename

	validates :name, :presence => true
	validates :interval_in_seconds, :presence => true

	# File validations
	validates_attachment_presence :filename, :unless => :url
	validates_attachment_content_type :filename, :content_type => 'text/xml', :message => 'Moet een XML bestand zijn'
	validates_attachment_size :filename, :less_than => 100.megabytes, :message => 'Moet kleiner zijn dan 100 MB'

	RECORDS = Hash.new

	
	def parse_feed
		self.last_parse = Time.now
		self.save

		category_key =  Feednode.find(:first, :conditions => {:feed_id => self.id, :field_id => Field.find_by_name('category')})
		producthash_key = Feednode.find(:first, :conditions => {:feed_id => self.id, :field_id => Field.find_by_name('unique hash')})

		if producthash_key
			if self.feed_path == nil
				if !self.url.blank?
					open_uri_fetched = open(self.url)
					doc = Nokogiri::XML(open(open_uri_fetched))
				else
					self.status = 'NoFile'
					self.save
				end
			else
				f = File.open(self.feed_path)
					doc = Nokogiri::XML(f)
				f.close
			end

			if category_key 

				foreign_categories = Array.new
				doc.xpath(self.xml_path+'/'+category_key.name).each do |node|
				    foreign_categories << node.text
				end

				if foreign_categories.count > 0
					foreign_categories.uniq.each do |category|
						if !ForeignCategory.find(:first, :conditions => {:feed_id => self.id, :name => category})	
						  newkey = ForeignCategory.new
						  newkey.feed_id = self.id
						  newkey.name = category
						  newkey.save
						end
					end
				end

			end	

			products = Array.new
			doc.xpath(self.xml_path).each do |product|
			    records = Feednode.where('field_id <> ?', Field.where('name' => 'dont use').first)
		       	productdata = Hash.new
				records.each do |record|
					if record.field.name == 'category'
						productdata[:category_id] = ForeignCategory.find_by_name(product.xpath(record.name).text).id
					else
						productdata[record.field.product_column_name.to_sym] = product.xpath(record.name).text
					end
				end
				productdata[:feed_id] = self.id
				productdata[:user_id] = self.user_id
				products << productdata
			end


			existing_product_hashes = Product.find(:all, :conditions => {:feed_id => self.id}, :select => "id").map{|p| p.id}
			
			products.each do |product|
				existing_product = Product.find(:last, :conditions => {:feed_id => self.id, :unique_hash => product[:unique_hash]})
				if existing_product
					existing_product.update_attributes(product)
					existing_product_hashes.delete(existing_product.id)
				else
					Product.create(product).save
				end
			end
			Product.update_all({:status => 'inactive'}, {:id => existing_product_hashes})
		end	
	end

	def map_feed
		if self.feed_path == nil
			if !self.url.blank?
				open_uri_fetched = open(self.url).read
				doc = Nokogiri::XML(open_uri_fetched)
			end
		else
			f = File.open(self.feed_path)
				doc = Nokogiri::XML(f)
			f.close
		end

		product_value = 0
	    product_path = nil

	    self.fetch_node_name(doc.xpath("./*").first)

	    RECORDS.each do |record|
	      if product_value < record[1]['count']
	        product_value = record[1]['count']
	        product_path  = record[1]['path']+'/'+record[0]
	      end
	    end

	    self.xml_path = product_path
	    self.save

		foreign_keys = Array.new
			doc.xpath(self.xml_path+"/*").each do |node|
		    foreign_keys << node.name
		end

		foreign_keys.uniq.each do |key|
			if !Feednode.find(:first, :conditions => {:feed_id => self.id,:name => key})
				newkey = Feednode.new
				newkey.feed_id = self.id
				newkey.name = key
				newkey.save
			end
		end

		self.status = 'user_fields'
		self.save

	end

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
		sub_nodes.map { |n| self.fetch_node_name(n, depth+1) } if sub_nodes.length > 0
	end



end
