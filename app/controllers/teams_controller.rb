# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :integer
#

class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :permit_rails_hidden_fields, only: [:invite]
  after_action :discard_flash, only: [:accept_invite, :refuse_invite, :remove_from_team]

  # GET /teams
  # GET /teams.json
  def index
    @teams = current_user.teams

    @team_invitations = current_user.team_invitations_as_receiver
  end
  
  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find(params[:id])
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    begin
      @team.owner_id = current_user.id
      @team.save!

      current_user.add_role :team_owner, @team
      current_user.add_role :member, @team
      current_user.teams << @team
      redirect_to teams_url, notice: 'Team was successfully created.'
    rescue Exception => e
      render :new
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if @team.update(team_params)
      redirect_to teams_url, notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    team_members = User.with_role :member, @team
    team_members.each do |member|
      member.remove_role :member, @team
      member.remove_role :team_owner, @team
    end
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  def invite

    # prepare current user's selected team id
    if params[:team_id]
      session[:team_id] = params[:team_id]
      @team = Team.find(params[:team_id])
    end
    if request.post?
      if params[:commit] == "Invite member"
        user_name = params["user_name"]
        first_name = user_name.split(" ")[0]
        last_name = user_name.split(" ")[1]
        invited_user = User.where("first_name = ? AND last_name = ?", first_name, last_name).first
        if invited_user.nil?
          flash[:alert] = "User specified is not in the system. Try again or invite using his email"
          render :invite and return 
        else
          # add a request to join this users team
          team_invitation = TeamInvitation.new
          team_invitation.sender = current_user
          team_invitation.receiver = invited_user
          team_invitation.team_id = session[:team_id]
          team_invitation.is_active = true
          team_invitation.save!

          flash[:notice] = "User #{user_name} has been notified of your request."
          session[:team_id] = ""
          redirect_to teams_url and return
        end
      else
        @invitation = params[:email]
        if @invitation == ""
          flash[:alert] = "Please enter a email"
          render :invite and return 
        else
          possible_user = User.find_by email: @invitation
          if possible_user
            # after 3rd attempt, block this user's attempt to invite for one hour
            flash[:alert] = "User #{@invitation} already exists in the system."
            render :invite and return 
          else
            email_validation = ValidatesEmailFormatOf::validate_email_format(@invitation)
            if email_validation.nil? #no errors
              User.invite!(:email => @invitation, :invited_on_team_id => session[:team_id])
              flash[:notice] = "Invitation sent successfully. Allow 1-2 min for the email to arrive"
              session[:team_id] = ""
              redirect_to teams_url and return
            else
              flash[:alert] = "This email is not valid. Please try again."
              render :invite and return 
            end
          end
        end
      end
    else
      Common::JsonGenerator.generate_user_names_json(current_user)
    end
  end

  def accept_invite
    team_invitation = TeamInvitation.find(params[:invitation_id])
    invited_user = team_invitation.receiver
    invited_user.teams << team_invitation.team
    invited_user.add_role :member, team_invitation.team
    team_invitation.team.projects.each do |project|
      invited_user.add_role :member, project
    end
    team_invitation.update_attribute(:is_active, false)

    @teams = current_user.teams
    @team_invitations = current_user.team_invitations_as_receiver
    respond_to do |format|
        format.js {  flash[:notice] = "Invitation accepted successfully" }
    end
  end

  def refuse_invite
    team_invitation = TeamInvitation.find(params[:invitation_id])
    team_invitation.update_attribute(:is_active, false)

    @team_invitations = current_user.team_invitations_as_receiver
    respond_to do |format|
        format.js {  flash[:notice] = "Invitation declined successfully" }
    end
  end

  def remove_from_team
    removed_user = User.find(params[:user_id])
    @team = Team.find(params[:team_id])
    removed_user.teams.delete(@team)
    removed_user.remove_role :member, @team 

    respond_to do |format|
        format.js {  flash[:notice] = "User #{removed_user.name} has been removed from team" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :description)
    end

    def permit_rails_hidden_fields
      params.permit(:email, :user_name, :utf8, :authenticity_token, :team_id, :commit)
    end

    def discard_flash
      flash.discard if request.xhr?
    end
end
