class Users::RegistrationsController < Devise::RegistrationsController

  def new 
    resource = build_resource({})
    respond_with resource
    #resource.sites.build
  end

  def edit
	  resource.build_usernotice
  end

  def notification

  end

  def organisation

  end

  def login_credentials

  end
end