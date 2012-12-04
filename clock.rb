require './config/boot'
require './config/environment'
require 'clockwork'
include Clockwork
require 'nokogiri'

RECORDS = Hash.new
KEYS = Array.new

every(60.seconds, 'Parse Feeds') { 

	feed = Feed.find(:first, :conditions => {:status => 'active'})

	if feed 
		f = File.open(feed.feed_path)
			doc = Nokogiri::XML(f)
		f.close

	    product_value = 0
	    product_path = nil

	    display_node_name(doc.xpath("./*").first)

	    RECORDS.each do |record|
	      if product_value < record[1]['count']
	        product_value = record[1]['count']
	        product_path  = record[1]['path']+'/'+record[0]
	      end
	    end

		KEYS.uniq.each do |key|
			if DatafeedKey.find(:first, :conditions => {:user_id => feed.user_id,:foreign_key_name => key})
			else
				newkey = DatafeedKey.new
				newkey.user_id = feed.user_id
				newkey.foreign_key_name = key
				newkey.save
			end
		end

	    category_field_id = Field.where('name' => 'category').first.id

	    if DatafeedKey.find(:first, :conditions => {:field_id => category_field_id})
	    	
	    else
	    	feed.status = 'pending'
	    	feed.save
	    end
	end
 }	


 def display_node_name(node, depth = 0)
   
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
        if sub_nodes.length > 1
          @listofitems = Hash.new
          @firstitem = Array.new
         
          sub_nodes.each do |l|
            # Values from array

            # Key names
            @firstitem << l.name

            @listofitems[l.name] = l.text 
          end
        end
    end
    sub_nodes.map { |n| display_node_name(n, depth+1) } if sub_nodes.length > 0
  end