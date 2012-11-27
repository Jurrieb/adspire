class Feed < ActiveRecord::Base
  attr_accessible :name, :xml_path, :feed_path
  has_many :products
end
