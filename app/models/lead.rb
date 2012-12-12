class Lead < ActiveRecord::Base
  attr_accessible :click_id, :product_id, :status, :user_id
end
