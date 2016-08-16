# == Schema Information
#
# Table name: sprints
#
#  id               :integer          not null, primary key
#  release_id       :integer
#  project_id       :integer
#  name             :string
#  status           :integer          default("created")
#  committed_effort :integer
#  done_effort      :integer
#  start_date       :datetime
#  release_date     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SprintsController < ApplicationController
	before_action :authenticate_user!
  before_action :set_variables, only: [:edit, :update, :destroy]

	def new
		@sprint = Sprint.new
		@sprint.start_date = DateTime.now
		@sprint.release_date = DateTime.now
		@project = Project.find(params[:project_id])
	end

	def create
		if request.post?
			@sprint = Sprint.new(sprint_params)
			if @sprint.start_date > @sprint.release_date
				flash[:alert] = "Cannot create sprint #{@sprint.name}. Reason: Start date must be set earlier than release date! Please try again."
				flash.keep(:alert)
				render js: "window.location = '#{project_story_map_path(:id => params[:sprint][:project_id])}'"
	    else
	    	begin
		    	@sprint.save!
			    sprint_backlog = SprintBacklog.new
			    sprint_backlog.sprint_id = @sprint.id
			    sprint_backlog.save!
			    @sprint.sprint_backlog = sprint_backlog

					@project = Project.find(@sprint.project_id)
					@sprints = @project.sprints
			    @sprints << @sprint
					@releases = @project.releases

			    flash[:notice] = "Sprint successfully created"
			  rescue Exception => e
			  	flash[:alert] = "Cannot create sprint #{@sprint.name}. Reason: #{e}. Please try again."
					flash.keep(:alert)
					render js: "window.location = '#{project_story_map_path(:id => params[:sprint][:project_id])}'"
			  end
			end
  	end
	end

	def edit
		@edit = true
    @statuses = Hash.new
    Sprint.statuses.each do |key, value|
      if key == "created" || key == "started"
        @statuses[key] = value
      end
    end
	end

	def update
		begin
			start_date = DateTime.parse(params[:sprint][:start_date]).strftime("%s")
			release_date = DateTime.parse(params[:sprint][:release_date]).strftime("%s")
			if start_date > release_date
				flash[:alert] = "Cannot update sprint. Reason: Start date must be set earlier than release date! Please try again."
				flash.keep(:alert)
				render js: "window.location = '#{project_story_map_path(:id => params[:sprint][:project_id])}'"
	    else
	    	if Sprint.where(:status => :started).where.not(:id => @sprint.id).first.nil?
			    @sprint.update_attributes!(sprint_params)

		      flash[:notice] = "Sprint #{@sprint.name} successfully updated"

		      if @sprint.is_started?
		      	if @project.committed_work == 0
		      		@project.commit_work
		      	end
		      	committed_effort = 0
		      	@sprint.sprint_backlog.user_stories.each do |user_story|
		      		committed_effort += user_story.effort
		      	end
		      	@sprint.update_column(:committed_effort, committed_effort)
		      end
					@releases = @project.releases 
					@sprints = @project.sprints
				else
					flash[:alert] = "Cannot start sprint #{@sprint.name}. Can only have 1 sprint started at a time."
					flash.keep(:alert)
					render js: "window.location = '#{project_story_map_path(:id => params[:sprint][:project_id])}'"
				end
			end
    rescue Exception => e
      flash[:alert] = "Cannot update sprint #{@sprint.name}. Reasons: #{e}. Please try again."
      flash.keep(:alert)
			render js: "window.location = '#{project_story_map_path(:id => params[:sprint][:project_id])}'"
    end
	end

	def destroy
		@sprint.sprint_backlog.user_stories.each do |user_story|
			user_story.is_task = false
			user_story.set_inactive
			user_story.update!
	    # current_user.user_stories.delete(task)
		end
    @sprint.destroy
		flash[:notice] = "Sprint destroyed"
		@releases = @project.releases 
		@sprints = @project.sprints
	end

	private

		def set_variables
      @sprint = Sprint.find(params[:id])
			@project = Project.find(@sprint.project_id)
		end

		def sprint_params
      params.require(:sprint).permit(:name, :project_id, :start_date, :release_date, :status)
    end
end
