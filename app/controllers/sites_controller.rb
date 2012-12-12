class SitesController < ApplicationController

	def index
		@user = User.find(current_user.id)
		@sites = @user.sites
	end

	def edit
		@site = Site.find_by_user_id(current_user.id)
	end

	def update
		@site = Site.find(params[:id])

		respond_to do |format|  
	        if @site.update_attributes(params[:site])
	          format.html { redirect_to :back, notice: 'Site was successfully updated.' }
	          format.json { head :no_content }
	        else
	          format.html { render action: "edit" }
	          format.json { render json: @sites.errors, status: :unprocessable_entity }
	        end
		end
    end

    def destroy
      @site = Site.find(params[:id])
      @site.destroy

      respond_to do |format|
        format.html { redirect_to sites_url }
        format.json { head :no_content }
      end
  end
end