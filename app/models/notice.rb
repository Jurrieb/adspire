class Notice < ActiveRecord::Base
  attr_accessible :lead, :sale, :feed, :result, :status, :merchant, :action
end
