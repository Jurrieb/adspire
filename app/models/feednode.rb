class Feednode < ActiveRecord::Base
  attr_accessible :name, :field_id, :feed_id
  belongs_to :field
end
