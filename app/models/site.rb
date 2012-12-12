class Site < ActiveRecord::Base
  
  belongs_to :user

  attr_accessible :name, :url, :description, :category_id, :active, :status

  validates :name, :presence => true
  validates_format_of :url, :with => URI::regexp
  
end