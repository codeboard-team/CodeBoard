class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :store_user_location!, if: :storable_location?

  helper_method :user_authority, :email_account, :current_path_last_string

  private
  def current_path_last_string
    request.path.split("/")[-1]
  end

  def email_account(user)
    user.email.split("@")[0]
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :avatar])
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

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

end