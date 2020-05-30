class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :user_authority, :email_account, :current_path_last_string
  
  
  private
  
  def current_path_last_string
    request.path.split("/")[-1]
  end

  def email_account(user)
    user.email.split("@")[0]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def user_authority
    if current_user.nil?
      return "guest"
    elsif current_user == Board.find_by(id: params[:id]).try(:user) || current_user == Board.find_by(id: params[:board_id]).try(:user)
      return "author"
    else
      return "user"
    end
  end

end