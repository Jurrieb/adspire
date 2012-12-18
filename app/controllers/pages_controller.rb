class PagesController < ApplicationController
  
  load_and_authorize_resource

  before_filter :authenticate_user!

  def dashboard

  end

end
