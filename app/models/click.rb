class Click < ActiveRecord::Base
  attr_accessible :ip_client, :product_id, :referer, :user_id
end
