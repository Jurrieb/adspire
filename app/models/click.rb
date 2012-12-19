class Click < ActiveRecord::Base

	attr_accessible :ip_client, :product_id, :referer, :user_id, :created_at

	has_one :lead

	scope :in_days, where("created_at >= ?", 30.days.ago)

end
