class DatafeedKey < ActiveRecord::Base
  attr_accessible :foreign_key_name, :field_id
  belongs_to :field
end
