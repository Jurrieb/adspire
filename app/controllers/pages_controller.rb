class PagesController < ApplicationController
  
  load_and_authorize_resource

  before_filter :authenticate_user!

  def dashboard

  end

  def sendData
	# All clicks for current user
	@clicks = Click.where(:user_id => current_user.id).in_days.order('created_at ASC')
	@clicks_by_date = @clicks.group_by { |t| t.created_at.beginning_of_day }
	
	# All leads for current user
	@leads = Lead.where(:user_id => current_user.id).in_days.order('created_at ASC')
	@leads_by_date = @leads.group_by { |t| t.created_at.beginning_of_day }

	# New array for graph
	@graph = Array.new
	# Add hash to Array with name and count
	@clicks_by_date.sort.each do |day, counts|
		@graph << { y: day.strftime("%Y-%m-%d"), click: counts.count }
	end

	@leads.each do |l|
		puts l.to_yaml
		if @leads[l.created_at.to_i] == @graph[l.created_at.to_i]
		   	
		   	@leads_by_date.sort.each do |day, counts|
		   		@graph << { y: day.strftime("%Y-%m-%d"), lead: counts.count }
		   	end
		end	
	end
	# Respond to JSON
	respond_to do |format|
		format.json { render json: @graph }
	end
  end
end
