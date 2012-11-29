class Feed < ActiveRecord::Base
  resourcify

  attr_accessible :name, :url, :xml_path, :feed_path
  has_many :products, :dependent => :delete_all
  
end
