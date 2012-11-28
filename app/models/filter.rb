class Filter < ActiveRecord::Base
  attr_accessible :user_id

  has_many :filteroptions
end
