# == Schema Information
#
# Table name: themes
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  status      :string
#  project_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ThemesController < ApplicationController
	before_action :authenticate_user!
  before_action :set_theme_and_project, only: [:edit, :update, :destroy]

	def new
		@theme = Theme.new
		@project = Project.find(params[:project_id])
	end

	def create
		if request.post?
			begin
				@theme = Theme.new(theme_params)
				@theme.set_active
		    @theme.save!

				@project = Project.find(@theme.project_id)
		    @themes = @project.themes
		    @themes << @theme

		    flash[:notice] = "Theme successfully created"
		  rescue Exception => e
	   		flash[:alert] = "Cannot create theme #{@theme.name}. Reason: #{e}. Please try again."
				flash.keep(:alert)
				render js: "window.location = '#{product_backlog_show_path(:id => params[:theme][:project_id])}'"
		  end
  	end
	end

	def edit
	end

	def update
		begin
			@theme.update_attributes!(theme_params)
      flash[:notice] = "Theme #{@theme.name} successfully updated"
			@themes = @project.themes
    rescue Exception => e
   		flash[:alert] = "Cannot update theme #{@theme.name}. Reason: #{e}. Please try again."
			flash.keep(:alert)
			render js: "window.location = '#{product_backlog_show_path(:id => params[:theme][:project_id])}'"
    end
	end

	def destroy
		@theme.set_inactive
    @theme.save!
		flash[:notice] = "Theme destroyed"
		@themes = @project.themes
	end

	private

		def set_theme_and_project
      @theme = Theme.find(params[:id])
			@project = Project.find(@theme.project_id)
		end

		def theme_params
      params.require(:theme).permit(:name, :description, :project_id)
    end
end
