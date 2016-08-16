# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  student_number         :string
#  phone_number           :string
#  skype                  :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  image_id               :string
#  image_filename         :string
#  image_size             :integer
#  image_content_type     :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  invited_on_team_id     :integer
#  last_seen              :datetime
#

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, only: [:grant_role, :revoke_role]
  before_action :set_form_variables, only: [:grant_role, :revoke_role]
	
	# ROLES = {0 => :guest, 1 => :member, 2 => :scrum_master, 4 => :product_owner, 5 => :team_owner, 6 => :admin}
	# somebody can be a guest for the web app represented by User
	# somebody can be a member for the web app represented by User
	# somebody can be an OWNER for a TEAM
	# somebody can be a member for a TEAM
	# somebody can be a member for a PROJECT
	# somebody can be a scrum_master for a PROJECT
	# somebody can be a product_owner for a PROJECT

	def show_profile
		@user = User.find(params[:user_id])
	end

	# ADMIN..TODO : create separate devise admin
	def manage_users
		if (can? :grant_role, User) || (can? :revoke_role, User)
			@users = User.all
			@teams = Team.all
			@projects = Project.where(active: true)
			@roles = Role.roles
		end
	end

	def grant_role
		chosen_user = User.find(params[:user_id])
		notice = "Role successfully granted to #{chosen_user.name}"
		if !params[:project_id].blank? && !params[:team_id].blank? #member for both
			chosen_project = Project.find(params[:project_id])
			chosen_team = Team.find(params[:team_id])
			chosen_user.add_role :member, chosen_project
			chosen_user.add_role :member, chosen_team
		elsif !params[:project_id].blank? #member , product_owner or scrum_master
			chosen_project = Project.find(params[:project_id])
			chosen_user.add_role params[:role], chosen_project
		elsif !params[:team_id].blank? #member or team_owner
			chosen_team = Team.find(params[:team_id])
			chosen_user.add_role params[:role], chosen_team
		else #no resource given
			if params[:role] == "member" || params[:role] == "product_owner" || 
				params[:role] == "scrum_master" || params[:role] == "team_owner"
				notice = "Choose to which resource you want to add the role #{params[:role]} to"
			else
				chosen_user.add_role params[:role]
			end
		end

		respond_to do |format|
      format.js {  flash[:notice] = "#{notice}" }
    end
	end

	def revoke_role
		chosen_user = User.find(params[:user_id])
		role = params[:role]
		if params[:resource_id]
			resource_id = params[:resource_id]
			chosen_team = Team.find(resource_id)
	    if chosen_team
				chosen_user.remove_role role, chosen_team
	    else
	      chosen_project = Project.find(resource_id)
	      if chosen_project
					chosen_user.remove_role role, chosen_project
	      end
	    end
		elsif params[:resource_type]
			chosen_user.remove_role role, params[:resource_type]
		else
			chosen_user.remove_role role
		end

		respond_to do |format|
      format.js {  flash[:notice] = "Role successfully removed from #{chosen_user.name}" }
    end
	end

	private
	def set_form_variables
		@users = User.all
		@teams = Team.all
		@projects = Project.where(active: true)
		@roles = Role.roles
	end

	def authenticate_admin
		if (!current_user.has_role? :admin)
			redirect_to root_path, alert: "Page does not exist."
		end
	end
end
