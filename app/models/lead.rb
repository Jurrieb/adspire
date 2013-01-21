class Lead < ActiveRecord::Base

	attr_accessible :click_id, :product_id, :status, :user_id, :created_at

	belongs_to :click

	scope :in_days, where("created_at >= ?", 30.days.ago)
	scope :complete_day, lambda { |day| where("created_at >= ? AND created_at <= ?", day.beginning_of_day, day.end_of_day) unless day.blank?}

end
