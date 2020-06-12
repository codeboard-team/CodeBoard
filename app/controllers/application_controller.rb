class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, 
  with: :record_not_found

  protect_from_forgery with: :exception

  before_action :store_user_location!, if: :storable_location?

  helper_method :user_authority, :email_account, :current_path_last_string

  private
  def current_path_last_string
    request.path.split("/")[-1]
  end

  def email_account(user)
    user.email.split("@")[0]
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

  def record_not_found
    render file: 'public/404.html', 
           status: 404, 
           layout: false
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  

end