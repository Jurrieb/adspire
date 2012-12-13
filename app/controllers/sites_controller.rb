class SitesController < ApplicationController

	def index
		@user = User.find(current_user.id)
		@sites = @user.sites
	end

	def new
		@site = Site.new
	end

	def create
		puts current_user
		params[:site][:user_id] = current_user.id
		@site = Site.new(params[:site])

	    respond_to do |format|
	      if @site.save
	        format.html { redirect_to sites_path, notice: 'Site is aangemeld.' }
	        format.json { render json: @site, status: :created, location: @site }
	      else
	        format.html { render action: "new" }
	        format.json { render json: @site.errors, status: :unprocessable_entity }
	      end
	    end
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
        format.html { redirect_to sites_path }
        format.json { head :no_content }
      end
  end
end