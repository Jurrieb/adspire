class PagesController < ApplicationController
  # User must have access
  load_and_authorize_resource
  before_filter :authenticate_user!

  # Show statistics in dashboard
  def dashboard 
	# List of all days
	list_of_days = (1.month.ago.to_date...Date.today).to_a

	@clicks = Click.where(:created_at => 1.month.ago.to_date...Date.today, :user_id => current_user.id).count
	@leads = Lead.where(:created_at => 1.month.ago.to_date...Date.today, :user_id => current_user.id).count


	# # List of all days
	# @list_of_days = (2.month.ago.to_date...Date.today).to_a
	# # New Hash of days
	# @datelist = Hash.new
	# # Set all dates to zero
	# @list_of_days.each do |k|
	#	# Convert to useable date
	#	date = k.to_date
	#	# Count all clicks per day
	#	@clicks = Click.complete_day(date).count
	#	# Add to array per day with clicks
	#	@datelist[date] = @clicks
	# end
  end

  def help
	
  end

  # All data is being fetched for display in graphical presentation
  def sendData
	# List of all days
	@list_of_days = (1.month.ago.to_date...Date.today).to_a
	# New Array for graph
	@graph = Array.new
	# Set all dates to zero
	@list_of_days.each do |k|
		# Convert to useable date
		date = k.to_date
		# Count all clicks/leads per day, per user
		@clicks = Click.complete_day(date).where(:user_id => current_user.id).count
		@leads = Lead.complete_day(date).where(:user_id => current_user.id).count
		# Add to array per day with clicks
		@graph << { y: date.strftime("%Y-%m-%d"), click: @clicks, lead: @leads}
	end
	#Respond to JSON
	respond_to do |format|
		format.json { render json: @graph }
	end
  end
end