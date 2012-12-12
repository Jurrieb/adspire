class SitesController < ApplicationController

	def index
		@user = User.find(current_user.id)
		@sites = @user.sites
	end

	def edit
		@user = User.find(current_user.id)
		@sites = @user.sites
	end

	def update
		@sites = Site.find(params[:id])

		respond_to do |format|  
	        if @sites.update_attributes(params[:site])
	          format.html { redirect_to :back, notice: 'Site was successfully updated.' }
	          format.json { head :no_content }
	        else
	          format.html { render action: "edit" }
	          format.json { render json: @sites.errors, status: :unprocessable_entity }
	        end
		end
    end
end