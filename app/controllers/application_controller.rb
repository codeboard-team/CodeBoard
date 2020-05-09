class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  rescue_from ActiveRecord::RecordNotFound, 
  with: :record_not_found

  before_action :configure_permitted_parameters, if: :devise_controller?
  



  private
  # def check_login
  #   redirect_to new_user_session_path unless current_user
  # end
  def record_not_found
    render file: 'public/404',
           status: 404
  end



  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name])
    end
end