class ClicksController < ApplicationController
  def create
  	 if Product.exists?(params[:product_id])
  	 	product = Product.find(params[:product_id])
  	 	click 				= Click.new
  	 	click.product_id 	= params[:product_id]
  	 	click.user_id		= params[:user_id]
  	 	click.ip_client		= request.remote_ip
  	 	click.referer		= request.referer
  	 	click.save
  	 	redirect_to product.url, :overwrite_params => { :parm => 'foo' }
  	 else
  	 end
  end
end
