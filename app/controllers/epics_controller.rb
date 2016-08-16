# == Schema Information
#
# Table name: epics
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  status      :string
#  project_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EpicsController < ApplicationController
	before_action :authenticate_user!
  before_action :set_epic_and_project, only: [:edit, :update, :destroy]

	def new
		@epic = Epic.new
		@project = Project.find(params[:project_id])
	end

	def create
		if request.post?
			begin
				@epic = Epic.new(epic_params)
				@epic.set_active
		    @epic.save!

				@project = Project.find(@epic.project_id)
				@epics = @project.epics
		    @epics << @epic
		    
		    flash[:notice] = "Epic successfully created"
	   	rescue Exception => e
	   		flash[:alert] = "Cannot create epic #{@epic.name}. Reason: #{e}. Please try again."
				flash.keep(:alert)
				render js: "window.location = '#{product_backlog_show_path(:id => params[:epic][:project_id])}'"
		  end
  	end
	end

	def edit
	end

	def update
		begin
		@epic.update_attributes!(epic_params)
      flash[:notice] = "Epic #{@epic.name} successfully updated"
			@epics = @project.epics
    rescue Exception => e
      flash[:alert] = "Cannot update epic #{@epic.name}. Reason: #{e}. Please try again."
			flash.keep(:alert)
			render js: "window.location = '#{product_backlog_show_path(:id => params[:epic][:project_id])}'"
    end
	end

	def destroy
    @epic.set_inactive
    @epic.save!
		flash[:notice] = "Epic destroyed"
		@epics = @project.epics
	end

	private

		def set_epic_and_project
      @epic = Epic.find(params[:id])
			@project = Project.find(@epic.project_id)
		end

		def epic_params
      params.require(:epic).permit(:name, :description, :project_id)
    end
end
