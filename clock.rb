require './config/boot'
require './config/environment'
require 'clockwork'
include Clockwork
require 'nokogiri'

RECORDS = Hash.new
KEYS = Array.new

every(120.seconds, 'parse products'){
	
	feed = Feed.find(:first, :conditions => {:status => 'active'}, :order => "created_at") 
	categorie_key =  DatafeedKey.find(:first, :conditions => {:feed_id => feed.id, :field_id => Field.find_by_name('Category')})
	producthash_key = DatafeedKey.find(:first, :conditions => {:feed_id => feed.id, :field_id => Field.find_by_name('Product hash')})

	if categorie_key && producthash_key

		f = File.open(feed.feed_path)
			doc = Nokogiri::XML(f)
		f.close

		foreign_categories = Array.new
		doc.xpath(feed.xml_path+'/*').each do |node|        
		  if node.name == category_key.name
		    foreign_categories << node.text
		  end
		end

		foreign_categories.uniq.each do |category|
			if !ForeignCategory.find(:first, :conditions => {:feed_id => feed.id,:name => category})	
			  newkey = ForeignCategory.new
			  newkey.feed_id = feed.feed_id
			  newkey.name = category
			  newkey.save
			end
		end

	else
		feed.status = 'user_fields'
		feed.save
	end

}


every(30.seconds, 'Startup Feeds') {

	feed = Feed.find(:first, :conditions => {:status => 'created'}, :order => "created_at") 

	if feed

		f = File.open(feed.feed_path)
			doc = Nokogiri::XML(f)
		f.close

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

		KEYS.uniq.each do |key|
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

def fetch_node_name(node, depth = 0)
	sub_nodes = node.xpath("./*")
	if sub_nodes.length < 1
	   KEYS << node.name
	else
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