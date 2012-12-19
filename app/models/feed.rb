class Feed < ActiveRecord::Base

	require 'nokogiri'
	require 'open-uri' 

	has_many :products
	has_many :feednodes, :autosave => true
	has_many :foreign_categories, :dependent => :delete_all

	attr_accessible :name, :url, :xml_path, :feed_path, :interval_in_seconds, :last_parse, :method_type, :feednodes_attributes
	accepts_nested_attributes_for :feednodes, :allow_destroy => true

	validates :name, :presence => true
	validates :interval_in_seconds, :presence => true

	RECORDS = Hash.new

	def parse_feed
		d = DelayedJob.first
		d.queue = '2'
		d.save
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
