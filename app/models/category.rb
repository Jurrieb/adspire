class Category < ActiveRecord::Base
resourcify
  
  attr_accessible :name

  has_many :product

end
