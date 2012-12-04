class Field < ActiveRecord::Base
  resourcify
  attr_accessible :name, :visible
end
