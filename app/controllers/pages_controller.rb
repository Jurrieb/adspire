class PagesController < ApplicationController
  
  load_and_authorize_resource

  before_filter :authenticate_user!

  def dashboard
  	@clicks = Click.where({:user_id => current_user.id}).count
  	@leads = Lead.where({:user_id => current_user.id}).count
  end

end
