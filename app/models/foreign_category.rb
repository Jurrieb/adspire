class ForeignCategory < ActiveRecord::Base
   resourcify
  attr_accessible :category_id, :name
  has_one :Category
end
