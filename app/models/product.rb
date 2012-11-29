class Product < ActiveRecord::Base
  attr_accessible :feed_id, :category_id, :name, :url, :description, :image, :price, :price_old
  belongs_to :feed
  belongs_to :category

  
end