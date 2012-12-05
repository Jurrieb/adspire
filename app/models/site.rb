class Site < ActiveRecord::Base
  attr_accessible :name, :url, :description, :category_id, :active, :status
  belongs_to :user
end
