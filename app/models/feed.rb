class Feed < ActiveRecord::Base
  attr_accessible :name, :url, :xml_path, :feed_path, :interval_in_seconds, :last_parse
  has_many :products, :dependent => :delete_all
  
end
