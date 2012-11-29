class ForeignCategory < ActiveRecord::Base
  
  attr_accessible :category_id, :name
  has_one :Category
end
