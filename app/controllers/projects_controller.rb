# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  team_id               :integer
#  name                  :string
#  description           :string
#  image_id              :string
#  image_filename        :string
#  image_size            :integer
#  image_content_type    :string
#  def_sprint_dur        :integer
#  def_proj_tips         :boolean
#  total_file_limit_size :integer
#  active                :boolean
#  committed_work        :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :artifacts, 
    :documents, :document_upload, :plan, :story_map, :move_user_story_to_sprint,
    :move_user_story_to_icebox, :work, :transform_to_task, :integrate_user_story,
    :create_task, :edit_task, :delete_task, :assign_task, :resign_task, :edit_user_task,
    :retrospective, :add_sprint_retrospective]
  before_action :authenticate_user!
  before_action :set_projects_vars
  before_action :check_team, only: [:show, :story_map, :plan, :work, :retrospective,
    :artifacts, :documents]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(:active => true)
  end

  # TODO: more teams to one project - maybeee..

  # GET /projects/1
  # GET /projects/1.json
  def show
    # @project = Project.find(params[:id])
    @product_owner = (User.with_role :product_owner, @project).first
    @scrum_master = (User.with_role :scrum_master, @project).first
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @edit = true
    if @project.team
      @team = true
    end
    @members = User.with_role :member, @project.team
    if @members.nil?
      @no_members = true
    end
    @product_owner = (User.with_role :product_owner, @project).first
    @scrum_master = (User.with_role :scrum_master, @project).first 
    if @scrum_master.nil?
      @scrum_master = @members.first
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    begin
      @project = Project.new(project_params)
      if params[:project][:image] == ""

        path = Rails.root.join("public","project_images", "#{Random.rand(4)}.jpg")
        File.open(path, "r") do |file|
          @project.image = file
        end
      end
      @project.def_sprint_dur = params[:def_sprint_dur]
      @project.save!
      product_backlog = ProductBacklog.new
      product_backlog.project_id = @project.id
      product_backlog.save!
      @project.product_backlog = product_backlog

      current_user.add_role :product_owner, @project
      @project.team.users.each do |member|
        member.add_role :member, @project
      end
      flash[:notice] = "Project #{@project.name} was successfully created"
      # redirect_back(fallback_location: projects_path)
      redirect_to projects_url
    rescue Exception => e
      render :new
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project.def_sprint_dur = params[:def_sprint_dur]
    if @project.update(project_params)
      flash[:notice] = "Project #{@project.name} was successfully updated"
      if params[:scrum_master_id]
        @project.team.users.each do |member|
          member.remove_role :scrum_master, @project
        end
        user = User.find(params[:scrum_master_id])
        user.add_role :scrum_master, @project
      end
      if params[:product_owner_id]
        @project.team.users.each do |member|
          member.remove_role :product_owner, @project
        end
        user = User.find(params[:product_owner_id])
        user.add_role :product_owner, @project
      end
      redirect_to projects_path(@project)
    else
      render :edit
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    project_members = User.with_role :member, @project
    # current_user.remove_role :product_owner, @project
    # project_members.each do |member|
    #   member.remove_role :member, @project
    # end

    @project.set_inactive
    @project.save!
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  # responsible for generating charts if enough data exists in the scrum process
  def artifacts
    #  You can only view charts for a single started sprint in scope of this project.
    sprint = Sprint.started(@project.id)
    if sprint.empty?
      flash[:alert] = "A sprint must be started for the Sprint burndown chart to work"
    else
      # 
    end
    @chart1 = Common::GraphFusioncharts.make_velocity_chart(@project)
    @chart2 = Common::GraphFusioncharts.make_release_burndown_chart(@project)
    @chart3 = Common::GraphFusioncharts.make_sprint_burndown_chart(@project)
  end

  def story_map
    @releases = @project.releases
    @sprints = @project.sprints
  end

  # TODO future: track history of previous sprints as different sprint burndown charts
  # def new_sprint_burndown
  #   @chart3 = Common::GraphFusioncharts.make_sprint_burndown_chart(@project)
  # end
  # TODO future: cron job that records for the sprint daily progress of todo/done for tasks

  def plan
    get_available_user_stories_and_sprints
  end

  def move_user_story_to_sprint
    @sprint = Sprint.find(params[:sprint_id])
    @user_story = UserStory.find(params[:user_story_id])
    @sprint.sprint_backlog.user_stories << @user_story
    @user_story.assign
    @user_story.save!

    flash[:notice] = "User story #{@user_story.name} moved to #{@sprint.name}"
    get_available_user_stories_and_sprints
  end

  def move_user_story_to_icebox
    @user_story = UserStory.find(params[:user_story_id])
    @sprint_backlog = @user_story.sprint_backlog
    @sprint_backlog.user_stories.delete(@user_story)
    @user_story.unassign
    @user_story.save!

    flash[:notice] = "User story #{@user_story.name} moved to icebox"
    get_available_user_stories_and_sprints
  end

  def get_available_user_stories_and_sprints
    @unassigned_user_stories = UserStory.where(["product_backlog_id = ?", @project.product_backlog.id]).where(:status => :unnasigned)
    @available_sprints = Sprint.where(["project_id = ?", @project.id]).where(:status => :created)
  end

  def work
    @sprint = Sprint.where(["project_id = ?", @project.id]).where(:status => :started)

    if (current_user.has_role? :product_owner, @project) || (current_user.has_role? :scrum_master, @project)
      @sprints = @project.sprints
      @available_user_stories = UserStory.where(["product_backlog_id = ? AND is_task = ?", 
        @project.product_backlog.id, false]).where(:status => [UserStory.statuses[:unnasigned], UserStory.statuses[:assigned]])
      @tasks = UserStory.where(["product_backlog_id = ? AND is_task = ?", 
        @project.product_backlog.id, true]).where(:status => :assigned)
      @available_sprints = Sprint.where(["project_id = ?", @project.id]).where(:status => :created)
    elsif current_user.has_role? :member, @project
      @free_tasks = UserStory.where(["product_backlog_id = ? AND is_task = ?", 
        @project.product_backlog.id, true]).where(:status => :assigned)
      @own_tasks = UserStory.belongs_user_and_project(@project.product_backlog.id, current_user.id).where.not(:status => :inactive).where.not(:status => :done)
    end
  end

  # PO, SM roles - first table for work function 
  def transform_to_task
    @sprint = Sprint.find(params[:sprint_id])
    @sprint_backlog = @sprint.sprint_backlog
    @user_story = UserStory.find(params[:user_story_id])
    @user_story.is_task = true
    @user_story.assign
    @user_story.sprint_backlog = @sprint_backlog
    @user_story.save!
    @sprint_backlog.user_stories << @user_story
    flash[:notice] = "User story transformed"
    redirect_to :action => :work, :id => @project.id
  end

  # PO, SM roles - first table for work function 
  def integrate_user_story
    @user_story = UserStory.find(params[:user_story_id])
    @user_story.integrate
    @user_story.save!
    flash[:notice] = "User story integrated"
    redirect_to :action => :work, :id => @project.id
  end

  # PO, SM roles - second table for work function 
  def create_task
    if request.post?
      begin
      @task = UserStory.new(create_task_params)
      @task.is_task = true
      @task.assign
      @sprint = Sprint.find(params[:sprint_id])
      @task.sprint_backlog = @sprint.sprint_backlog
      @task.product_backlog = @project.product_backlog
      @sprint.sprint_backlog.user_stories << @task
      @task.save!
      flash[:notice] = "Task Created"

      rescue Exception => e
        flash[:alert] = "Cannot create task. Reason: #{e}. Please try again"
      end
      redirect_to :action => :work, :id => @project.id and return
    end
    @available_sprints = Sprint.where(["project_id = ?", @project.id]).where(:status => :created)
    @efforts = [1,2,3,5,8,13,21,34]
    @task = UserStory.new
  end

  # PO, SM roles - second table for work function 
  def edit_task
    @task = UserStory.find(params[:user_story_id])
    if request.post?
      begin
      @sprint = Sprint.find(params[:sprint_id])
      @sprint_backlog = @sprint.sprint_backlog
      if !@task.sprint_backlog.nil?
        # cleanup..
        previous_sprint_backlog = @task.sprint_backlog
        previous_sprint_backlog.user_stories.delete(@task)
        @task.sprint_backlog = nil
      end
      @task.update_attributes!(edit_task_params)
      @task.update_column(:sprint_backlog_id, @sprint_backlog.id)
      @sprint_backlog.user_stories << @task

      flash[:notice] = "Task updated"

      rescue Exception => e
        flash[:alert] = "Cannot update task. Reason: #{e}. Please try again"
      end
      redirect_to :action => :work, :id => @project.id and return
    end
    @available_sprints = Sprint.where(["project_id = ?", @project.id]).where(:status => :created)
    @efforts = [1,2,3,5,8,13,21,34]
  end

  # PO, SM roles - second table for work function 
  def delete_task
    @user_story = UserStory.find(params[:user_story_id])
    @user_story.destroy
    flash[:notice] = "Task deleted"
    redirect_to :action => :work, :id => @project.id
  end

  # member role - first table for work function
  def assign_task
    begin
      task = UserStory.find(params[:user_story_id])
      task.take
      task.save!
      current_user.user_stories << task
      flash[:notice] = "Task assigned"
    rescue Exception => e
      flash[:alert] = "Cannot assign task. Reason: #{e}. Please try again"
    end
    redirect_to :action => :work, :id => @project.id and return
  end

  # member role - second table for work function
  def resign_task
    begin
      task = UserStory.find(params[:user_story_id])
      task.assign
      task.save!
      current_user.user_stories.delete(task)
      flash[:notice] = "Task removed"
    rescue Exception => e
      flash[:alert] = "Cannot remove task. Reason: #{e}. Please try again"
    end
    redirect_to :action => :work, :id => @project.id and return
  end

  # member role - second table for work function
  # change status of the task only if sprint is not finished
  def edit_user_task
    if request.post?
      begin
        @task = UserStory.find(params[:user_story_id])
        @task.update_column(:status, params[:user_story][:status])
        if @task.status == "done"
          @task.update_column(:finished_date, DateTime.now)
        end
        flash[:notice] = "Task status updated"
      rescue Exception => e
        flash[:alert] = "Cannot update task. Reason: #{e}. Please try again"
      end
      redirect_to :action => :work, :id => @project.id and return
    end
    @task = UserStory.find(params[:user_story_id])
    @edit = true
    if @task.sprint_backlog.sprint.is_done?
      flash[:alert] = "Cannot edit task. Sprint is finished!"
      @edit = false
    end
    @statuses = Hash.new
    UserStory.statuses.each do |key, value|
      if key == "started" || key == "to_be_reviewed" || key == "to_be_validated" || key == "done"
        @statuses[key] = value
      end
    end
  end

  def retrospective
    @sprints = @project.sprints
    @sprints.each do |sprint|
      if sprint.is_done?
        @retrospective = Retrospective.new
        # @retrospective.sprint = sprint
        @sprint = sprint
        break
      end
    end
    @finished_sprints = Sprint.where(["project_id = ?", @project.id]).where(:status => [Sprint.statuses[:done], Sprint.statuses[:cancelled]])
  end

  def documents
    check_toggle

    # @resource_id = @project.id
    @attachment_type = "all_project_documents"
    @documents = @project.documents
    @desired_resource = "Project documents"
    @product_backlog = @project.product_backlog
    @user_stories = @product_backlog.user_stories    
    @sprints = @project.sprints
    @releases = @project.releases
    if params[:attachment_type]
      case params[:attachment_type]
      when "all_project_documents"
        @desired_resource = "Project documents"
      when "specific_user_story_documents"
        @user_story = UserStory.find(params[:user_story_id])
        @documents = @user_story.documents
        @resource_id = @user_story.id
        @desired_resource = "User story documents"
      when "specific_release_documents"
        @release = Release.find(params[:release_id])
        @documents = @release.documents
        @resource_id = @release.id
        @desired_resource = "Release documents"
      when "specific_sprint_documents"
        @sprint = Sprint.find(params[:sprint_id])
        @documents = @sprint.documents
        @resource_id = @sprint.id
        @desired_resource = "Sprint documents"
      when "all_user_story_documents"
        @desired_resource = "All user stories documents"
      when "all_release_documents"
        @desired_resource = "All releases documents"
      when "all_sprint_documents"
        @desired_resource = "All sprints documents"
      end
      @attachment_type = params[:attachment_type]
    end
  end

  def close_popup
  end

  def check_team
    set_project
    if !@project.team
      flash[:alert] = "Add a team to project before you proceed!"
      redirect_to edit_project_path(@project.id) and return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def project_params
      # params.require(:def_sprint_dur)
      # params.require(:project).permit(:name, :description,
      #   :def_proj_tips, :active, :image, :team_id, project_attachments_files: [])
      params.require(:project).permit(:name, :description,
        :def_proj_tips, :active, :image, :team_id, documents_files: [])
    end

    def create_task_params
      params.require(:user_story).permit(:name, :description, :effort, :priority, 
        :project_id, :sprint_backlog_id, :acceptance_condition)
    end

    def edit_task_params
      params.require(:user_story).permit(:name, :description, :effort, :priority, 
        :project_id, :sprint_backlog_id, :acceptance_condition)
    end

    def set_projects_vars
      @available_sprint_days =* (7..31)
      @teams = current_user.teams
    end

    def check_toggle
      session[:see_only_active] = params[:see_only_active] || false
    end
end
