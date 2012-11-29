class Filteroption < ActiveRecord::Base
  
  attr_accessible :filter_id, :type, :value

  belongs_to :filter
end
