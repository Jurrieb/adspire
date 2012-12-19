class PagesController < ApplicationController
  
  load_and_authorize_resource

  before_filter :authenticate_user!

  def dashboard

  end

  def sendData 
	# All clicks for current user
	@clicks = Click.where(:user_id => current_user.id).order('created_at ASC')
	# Group all clicks by day
	@clicks_part = @clicks.group_by { |t| t.created_at.beginning_of_day }
	# New array for graph
	@graph = Array.new
	# Add hash to Array with name and count
	@clicks_part.sort.each do |day, counts|
		@graph << { y: day.strftime('%d'), click: counts.count }
	end
	# Respond to JSON
	respond_to do |format|
		format.json { render json: @graph }
	end
  end
end
