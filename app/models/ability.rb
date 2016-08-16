class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
        can :manage, :all
    # elsif user.has_role? :member, User
        # access to menu, can create teams, projects,
        # can view teams, projects that he's part of
    # inside teams, ask current_user.has_role? :owner, team
    # elsif user.team_owner?
    #     can :manage, :Team {owner_id: user.id}
    # same for these two
    elsif user.has_role? :product_manager
        can :manage, :Project
    elsif user.has_role? :scrum_master
        can :view, :Project
        can :change, :Project
    else
    # user is not logged in. he is a guest
        # can view main page of the web app
        # has access to about,contact, register, sign_in
    end
    # we also have roles team_member and project_member 
  end
end
