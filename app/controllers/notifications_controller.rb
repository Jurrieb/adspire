class NotificationsController < ApplicationController

	def settings
		@notice = Notice.find_by_user_id(current_user.id)

		if @notice.blank?
			@notice = Notice.new
			# Standard values
			@notice.user_id = current_user.id
			@notice.lead = true
			@notice.sale = true
			@notice.feed = false
			@notice.result = true
			@notice.status = false
			@notice.merchant = false
			@notice.action = true
			@notice.save!
		end

	end

	def settings_update
		
		@notice = Notice.find_by_user_id(current_user.id)
		puts @notice.to_yaml

		respond_to do |format|  
	        if @notice.update_attributes(params[:notice])
	          format.html { redirect_to :back, notice: 'Notice was successfully updated.' }
	          format.json { head :no_content }
	        else
	          format.html { render action: "edit" }
	          format.json { render json: @notice.errors, status: :unprocessable_entity }
	        end
		end
	end
end
