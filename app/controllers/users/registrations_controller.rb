class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    resource.add_role :member, User
  end

  def update
    super
  end
end