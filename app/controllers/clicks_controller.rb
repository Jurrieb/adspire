class ClicksController < ApplicationController
  # Set a click for product, if done make a new notification
  def create
  	 if Product.exists?(params[:product_id])
  	 	product = Product.find(params[:product_id])
  	 	click 				= Click.new
  	 	click.product_id 	= params[:product_id]
  	 	click.user_id		= params[:user_id]
  	 	click.ip_client		= request.remote_ip
  	 	click.referer		= request.referer
  	 	click.save

      notification = Notification.new
      notification.user_id = params[:user_id]
      notification.message = "U heeft een nieuwe click ontvangen."
      notification.url = nil
      notification.deleted = false
      notification.save

		  redirect_to product.url
	 else
	 end
  end
end
