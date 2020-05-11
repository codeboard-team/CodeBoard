class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  



  private
  # def check_login
  #   redirect_to new_user_session_path unless current_user
  # end



  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name])
    end
end