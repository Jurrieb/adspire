require './config/boot'
require './config/environment'
require 'clockwork'
include Clockwork
require 'nokogiri'

RECORDS = Hash.new

every(60.seconds, 'Parse Feeds') { 

	feed = Feed.find(:last, :conditions => {:status => 'active'}, :order => "updated_at")
	if feed 
		f = File.open(feed.feed_path)
			doc = Nokogiri::XML(f)
		f.close
		if feed.xml_path.blank?
		    product_value = 0
		    product_path = nil

		    display_node_name(doc.xpath("./*").first)

		    RECORDS.each do |record|
		      if product_value < record[1]['count']
		        product_value = record[1]['count']
		        product_path  = record[1]['path']+'/'+record[0]
		      end
		    end
		    feed.xml_path = product_path
	    	feed.save
		end
		foreign_fields = Array.new
		doc.xpath(feed.xml_path+'/*').each do |node|
    		foreign_fields << node.name
		end
		foreign_fields.uniq.each do |key|
			if DatafeedKey.find(:first, :conditions => {:user_id => feed.user_id,:foreign_key_name => key})
			else
				newkey = DatafeedKey.new
				newkey.user_id = feed.user_id
				newkey.foreign_key_name = key
				newkey.save
			end
		end
		category_field_id = Field.where('name' => 'category').first.id
	    category_key = DatafeedKey.find(:first, :conditions => {:user_id => feed.user_id, :field_id => category_field_id})
	    if category_key
	    	foreign_categories = Array.new
			doc.xpath(feed.xml_path+'/*').each do |node|	      
		      if node.name == category_key.foreign_key_name
		        foreign_categories << node.text
		      end
   			end
			foreign_categories.uniq.each do |category|
				if ForeignCategory.find(:first, :conditions => {:user_id => feed.user_id,:name => category})
				else
					newkey = ForeignCategory.new
					newkey.user_id = feed.user_id
					newkey.name = category
					newkey.save
				end
			end
		 	dont_use_field_id = Field.where('name' => 'Dont use').first
			records = DatafeedKey.where('field_id <> ?', dont_use_field_id.id)
			doc.xpath(feed.xml_path).each  do |product|
				productdata = Hash.new
				records.each do |record|
					if record.field.name == 'category'
					  category = ForeignCategory.find_by_name(product.xpath(record.foreign_key_name).text)
					  productdata['category_id'] = category.category_id
					  productdata['feed_id'] = feed.id
					else
					  productdata[record.field.name] = product.xpath(record.field.name).text
					end
				end
				puts productdata
			end
	    else
	    	feed.status = 'pending'
	    	feed.save
	    end
	end
 }	


 def display_node_name(node, depth = 0)
   
    sub_nodes = node.xpath("./*")
    if sub_nodes.length < 1
    else  
        if RECORDS[node.name].blank?
          RECORDS[node.name] = Hash.new
          RECORDS[node.name]['count'] = 1
          RECORDS[node.name]['path'] = node.parent.path()
        else 
          RECORDS[node.name]['count'] += 1
        end
    end
    sub_nodes.map { |n| display_node_name(n, depth+1) } if sub_nodes.length > 0
  end