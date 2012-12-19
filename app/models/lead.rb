class Lead < ActiveRecord::Base

	attr_accessible :click_id, :product_id, :status, :user_id, :created_at

	belongs_to :click

	scope :in_days, where("created_at >= ?", 30.days.ago)


end
