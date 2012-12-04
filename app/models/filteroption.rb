class Filteroption < ActiveRecord::Base
  resourcify
  attr_accessible :filter_id, :type, :value

  belongs_to :filter
end
