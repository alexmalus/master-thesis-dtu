class DashboardsController < ApplicationController
	# Once again note that, for models that are named differently, this method will have a different name (authenticate_admin! for Admin model).
	before_action :authenticate_user!, only: [:secret]

	def index
		if user_signed_in?
			@teams = current_user.teams
		end
	end

	def contact
		@user_feedback = UserFeedback.new
		if request.post?
			begin
				@user_feedback.name = params[:name]
				@user_feedback.contact_info = params[:contact_info]
				@user_feedback.description = params[:description]
				@user_feedback.save!
	    	flash[:notice] =  'Thank you. Your form has been submitted. We will get back to you as soon as possible.'
	    	redirect_to :action => :contact
			rescue Exception => e
			end
		end
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
	  def user_feedback_params
	    params.require(:name)
	    params.require(:contact_info)
	    params.require(:description)
	  end
end