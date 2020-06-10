class Users::SessionsController < Devise::SessionsController
  def create
    super
    unless session["login_type"]
      session["login_type"] = 'local'
    end
  end
  def sign_in_and_redirect(resource_or_scope, *args)
    options  = args.extract_options!
    scope    = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope
    sign_in(scope, resource, options)
    redirect_to root_path
end