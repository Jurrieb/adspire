class PagesController < ApplicationController
  
  load_and_authorize_resource

  before_filter :authenticate_user!

  def dashboard

	KEUZE TUSSEN PG EN SQL
		
	# Postgresql
	#@clicks = Click.select("count(*) as c, date_part('year', created_at) as y, date_part('month', created_at) as m").
    #            group("y", "m").
    #            where({:user_id => current_user.id})

    #SQL

    #@clicks = Click.select("count(distinct(id)) as id, date_trunc('month', created_at) as date")
    # .group('date')

            



	#@clicks = Click.where({:user_id => current_user.id}).count(:group => "strftime('%m',date")
	# @leads = Lead.where({:user_id => current_user.id}).count(:group => "strftime('%m',date")

	#@leads += 999
	#@clicks += 234

	puts @clicks
	#puts @leads

  end

end
