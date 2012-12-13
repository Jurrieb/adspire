class NotificationsController < ApplicationController

	def settings
		@usernotice = Usernotice.find_by_user_id(current_user.id)

		if @usernotice.blank?
			@usernotice = Usernotice.new
			# Standard values
			@usernotice.user_id = current_user.id
			@usernotice.lead = true
			@usernotice.sale = true
			@usernotice.feed = false
			@usernotice.result = true
			@usernotice.status = false
			@usernotice.merchant = false
			@usernotice.action = true
			@usernotice.save!
		end
	end

	def settings_update
		@usernotice = Usernotice.find_by_user_id(current_user.id)

		respond_to do |format|  
	        if @usernotice.update_attributes(params[:usernotice])
	          format.html { redirect_to notifications_settings_path, notice: 'Notice was successfully updated.' }
	          format.json { head :no_content }
	        else
	          format.html { render action: "edit" }
	          format.json { render json: @usernotice.errors, status: :unprocessable_entity }
	        end
		end
	end
end
