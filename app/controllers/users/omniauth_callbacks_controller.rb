# frozen_string_literal: true
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def github 
    @user = User.create_from_provider_data(request.env['omniauth.auth'])  
    if @user.persisted?
      session["login_type"] = "github"
      sign_in_and_redirect @user, :event => :authentication
      # set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
    else
      flash[:error] = 'There was a problem signing you in through Github. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end  
  end

  def google_oauth2
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      session["login_type"] = "google"
      sign_in_and_redirect @user
      # set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?     
    else
      flash[:error] = 'There was a problem signing you in through Github. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end  
  end

  def failure
    flash[:error] = 'There was a problem signing you in . Please register or try signing in later.'
    redirect_to new_user_registration_url
  end

  def sign_in_and_redirect(resource_or_scope, *args)
    options  = args.extract_options!
    scope    = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope
    sign_in(scope, resource, options)
    redirect_to root_path
  end

end
