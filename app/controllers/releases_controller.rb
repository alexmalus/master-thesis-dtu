# == Schema Information
#
# Table name: releases
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  status      :integer          default("done")
#  project_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ReleasesController < ApplicationController
	before_action :authenticate_user!
  before_action :set_release_and_project, only: [:edit, :update, :destroy]

	def new
		@release = Release.new
		@release.status = :done
		@project = Project.find(params[:project_id])
	end

	def create
		if request.post?
			@release = Release.new(release_params)
			@project = Project.find(params[:release][:project_id])
			begin
				@release.sprint = Sprint.find(params[:sprint_id])
		    @release.save!

		    # if its status is cancelled, cancel the sprint as well, cancel the tasks inside the sprint..
		    @sprint = @release.sprint
		    if @release.status == "done"
		    	done_effort = 0
		    	@sprint.sprint_backlog.user_stories.each do |user_story|
	      		if user_story.status == "taken" || user_story.status == "started" ||
	      			user_story.status == "to_be_reviewed" || user_story.status == "to_be_validated"
		      			user_story.unassign
		      			user_story.user_id = nil
		      			user_story.is_task = false
		      			user_story.save!
	      		end
	      		if user_story.status == "done"
	      			done_effort += user_story.effort
	      		end
	      	end
	      	@sprint.done_effort = done_effort
	      	@sprint.done

	      	commit_work = SprintDoneWork.new
	      	commit_work.sprint_id = @sprint.id
	      	commit_work.project_id = @project.id
	      	commit_work.committed_work = done_effort
	      	commit_work.save!

	      	@sprint.sprint_done_work = commit_work
	      	@sprint.save!
		    elsif @release.status == "cancelled"
		    	@sprint.sprint_backlog.user_stories.each do |user_story|
	      		if user_story.status == "taken" || user_story.status == "started" ||
	      			user_story.status == "to_be_reviewed" || user_story.status == "to_be_validated" ||
	      			user_story.status == "done"
		      			user_story.unassign
		      			user_story.user_id = nil
		      			user_story.is_task = false
		      			user_story.update!
	      		end
	      	end
	      	@sprint.cancel
	      	@sprint.save!
		    end

				@project = Project.find(@release.project_id)
				@releases = @project.releases
				attached_sprint = Sprint.find(params[:sprint_id])
				attached_sprint.release = @release
				@sprints = @project.sprints
		    @releases << @release
		    
		    flash[:notice] = "Release successfully created"
		   rescue Exception => e
		   		flash[:alert] = "Cannot create release #{@release.name}. Reason: #{e}. Please try again."
					flash.keep(:alert)
					render js: "window.location = '#{project_story_map_path(:id => params[:release][:project_id])}'"
		   end
  	end
	end

	def edit
		@edit = true
	end

	def update
		begin
		@release.update_attributes!(release_params)
      flash[:notice] = "Release #{@release.name} successfully updated"
      attached_sprint = Sprint.find(params[:sprint_id])
			attached_sprint.release = @release
			@sprints = @project.sprints
			@releases = @project.releases
    rescue Exception => e
      flash[:alert] = "Cannot update release #{@release.name}. Reason: #{e}. Please try again."
			flash.keep(:alert)
			render js: "window.location = '#{project_story_map_path(:id => params[:release][:project_id])}'"
    end
	end

	def destroy
		sprint = @release.sprint
		sprint.release = nil
		project = @release.project
		project.releases.delete(@release)

    @release.destroy
		flash[:notice] = "Release destroyed"
		
		@sprints = @project.sprints
		@releases = @project.releases
	end

	private

		def set_release_and_project
      @release = Release.find(params[:id])
			@project = Project.find(@release.project_id)
		end

		def release_params
			params.permit(:sprint_id)
      params.require(:release).permit(:name, :description, :project_id, :status)
    end
end
