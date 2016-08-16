class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  # unless Rails.application.config.consider_all_requests_local
  #   rescue_from Exception, with: :handle_exception
  # end

	protected

	def configure_permitted_parameters
	  devise_parameter_sanitizer.permit(:sign_up) do |u| 
      u.permit({ other_attrs: [] }, :email, :password, :password_confirmation, 
        :current_password, :first_name, :last_name, :student_number,
        :phone_number, :skype, :image)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u| 
      u.permit({ other_attrs: [] }, :email, :password, :password_confirmation, 
        :current_password, :first_name, :last_name, :student_number,
        :phone_number, :skype, :image, :remove_image)
    end
    devise_parameter_sanitizer.permit(:invite) do |u|
      u.permit(:invited_on_team_id, :email)
    end
    devise_parameter_sanitizer.permit(:accept_invitation) do |u|
      u.permit(:first_name, :last_name, :password, :password_confirmation,
        :invitation_token)
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
