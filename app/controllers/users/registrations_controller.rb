class Users::RegistrationsController < Devise::RegistrationsController

  def new 
    resource = build_resource({})
    respond_with resource
    #resource.sites.build
  end
end
