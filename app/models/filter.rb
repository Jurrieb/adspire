class Filter < ActiveRecord::Base
  resourcify
  attr_accessible :user_id

  has_many :filteroptions
end
