class ApplicationController < ActionController::Base
	protect_from_forgery

	before_filter :fetch_notifications

	# If user has no access
	rescue_from CanCan::AccessDenied do |exception|
		redirect_to new_user_session_path, :alert => exception.message
	end

	# Show notifications if there is any left
	def fetch_notifications
		if !current_user.blank?
			@notifications = Notification.where({:deleted => false, :user_id => current_user.id}).order('created_at DESC').limit(8)
		else
			@notifications = Array.new
		end
	end
end