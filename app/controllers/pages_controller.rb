class PagesController < ApplicationController
  
  load_and_authorize_resource

  before_filter :authenticate_user!

  def dashboard

  end

  def sendData
	# All clicks for current user
	@clicks = Click.where(:user_id => current_user.id).in_days.order('created_at ASC')
	# Leads for clicks
	@leads_from_clicks = Lead.where(:status => 1, :user_id => current_user.id).in_days.order('created_at ASC')
	
	# Group by day
	@clicks_by_date = @clicks.group_by { |t| t.created_at.beginning_of_day }
	@leads_by_date = @leads_from_clicks.group_by { |t| t.created_at.beginning_of_day }

	# New array for graph
	@graph = Array.new
	
	# Add hash to Array with name and count
	@clicks_by_date.sort.each do |day, counts|
		@graph << { y: day.strftime("%Y-%m-%d"), click: counts.count }
	end

	# Add hash to Array with name and count
	@leads_by_date.sort.each do |day, counts|
		@graph << { y: day.strftime("%Y-%m-%d"), lead: counts.count }
	end

	# Respond to JSON
	respond_to do |format|
		format.json { render json: @graph }
	end
  end
end
