# == Schema Information
#
# Table name: user_stories
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :string
#  acceptance_condition :string
#  priority             :integer
#  effort               :integer
#  status               :integer          default("unnasigned")
#  is_task              :boolean          default(FALSE)
#  finished_date        :datetime
#  product_backlog_id   :integer
#  sprint_backlog_id    :integer
#  epic_id              :integer
#  theme_id             :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class UserStoriesController < ApplicationController
	before_action :authenticate_user!
  before_action :set_user_story_and_product_backlog, only: [:edit, :update, :destroy]

	def new
		@user_story = UserStory.new
		@product_backlog = ProductBacklog.find(params[:product_backlog_id])
		@project = @product_backlog.project
		@efforts = [1,2,3,5,8,13,21,34]

		@themes = @product_backlog.project.themes
		@epics = @product_backlog.project.epics
    @available_sprints = Sprint.where(["project_id = ?", @product_backlog.project.id]).where(:status => :created)
	end

	def create
		if request.post?
			begin
				@product_backlog = ProductBacklog.find(params[:product_backlog_id])
				@user_story = UserStory.new(user_story_params)
		    @user_story.save!
		    if params[:sprint_id] && !params[:sprint_id].empty?
		    	sprint = Sprint.find(params[:sprint_id])
		    	@user_story.assign
		    	@user_story.update_column(:sprint_backlog_id, sprint.sprint_backlog.id)
		    	@user_story.save!
		    	sprint.sprint_backlog.user_stories << @user_story
		    end

		    @product_backlog.user_stories << @user_story
		    @project = @product_backlog.project

		    @mvp_themes = Hash.new
		    @theme_user_story = Hash.new
				@themes = @project.themes.select { |theme| theme.status == "active" }
				@themes.each do |theme|
					@theme_user_story[theme.id] = theme.user_stories.select { |user_story| user_story.status == "unnasigned" }
					@mvp_themes[theme.id] = UserStory.gethighestpriority(@theme_user_story[theme.id])
				end

				@mvp_epics = Hash.new
				@epic_user_story = Hash.new
				@epics = @project.epics.select { |epic| epic.status == "active" }
				@epics.each do |epic|
					@epic_user_story[epic.id] = epic.user_stories.select { |user_story| user_story.status == "unnasigned" }
					@mvp_epics[epic.id] = UserStory.gethighestpriority(@epic_user_story[epic.id])
				end
				icebox_user_stories = @product_backlog.user_stories.where(:epic_id => nil).where(:theme_id => nil)
				@icebox_user_stories = icebox_user_stories.select { |user_story| user_story.status == "unnasigned" }
				@mvp_user_story = UserStory.gethighestpriority(@product_backlog.user_stories)
		    
		    flash[:notice] = "User story successfully created"
		    redirect_to product_backlog_show_path(:id => @project.id)
		  rescue Exception => e
		  	flash[:alert] = "Cannot create user story #{params[:user_story][:name]}. Reason: #{e}. Please try again."
				flash.keep(:alert)
				# product_backlog = ProductBacklog.find(params[:user_story][:product_backlog_id])
				redirect_to product_backlog_show_path(:id => @product_backlog.id)
		  end
  	end
	end

	def edit
		@efforts = [1,2,3,5,8,13,21,34]
		@themes = @product_backlog.project.themes
		@epics = @product_backlog.project.epics
    @available_sprints = Sprint.where(["project_id = ?", @product_backlog.project.id]).where(:status => :created)
	end

	def update
		begin
			@user_story.update_attributes!(user_story_params)
			if params[:sprint_id]
	  		@sprint = Sprint.find(params[:sprint_id])
	      @sprint_backlog = @sprint.sprint_backlog
	      if !@user_story.sprint_backlog.nil?
	        # cleanup..
	        previous_sprint_backlog = @user_story.sprint_backlog
	        previous_sprint_backlog.user_stories.delete(@user_story)
	        @user_story.sprint_backlog = nil
	      end
	      @user_story.update_column(:sprint_backlog_id, @sprint_backlog.id)
	      @user_story.assign
	      @user_story.save!
	      @sprint_backlog.user_stories << @user_story
	    end

			@mvp_themes = Hash.new
	    @theme_user_story = Hash.new
			@themes = @project.themes.select { |theme| theme.status == "active" }
			@themes.each do |theme|
				@theme_user_story[theme.id] = theme.user_stories.select { |user_story| user_story.status == "unnasigned" }
				@mvp_themes[theme.id] = UserStory.gethighestpriority(@theme_user_story[theme.id])
			end

			@mvp_epics = Hash.new
			@epic_user_story = Hash.new
			@epics = @project.epics.select { |epic| epic.status == "active" }
			@epics.each do |epic|
				@epic_user_story[epic.id] = epic.user_stories.select { |user_story| user_story.status == "unnasigned" }
				@mvp_epics[epic.id] = UserStory.gethighestpriority(@epic_user_story[epic.id])
			end
			icebox_user_stories = @product_backlog.user_stories.where(:epic_id => nil).where(:theme_id => nil)
			@icebox_user_stories = icebox_user_stories.select { |user_story| user_story.status == "unnasigned" }
			@mvp_user_story = UserStory.gethighestpriority(@product_backlog.user_stories)

	    flash[:notice] = "User story #{@user_story.name} successfully updated"
	    redirect_to product_backlog_show_path(:id => @product_backlog.project_id)
    rescue Exception => e
    	flash[:alert] = "Cannot update user story #{@user_story.name}. Reason: #{e}.Please try again."
			flash.keep(:alert)
			product_backlog = ProductBacklog.find(params[:user_story][:product_backlog_id])
			redirect_to product_backlog_show_path(:id => product_backlog.project_id)
		end
	end

	def destroy
		@user_story.set_inactive
    @user_story.save!
		
		@mvp_themes = Hash.new
    @theme_user_story = Hash.new
		@themes = @project.themes.select { |theme| theme.status == "active" }
		@themes.each do |theme|
			@theme_user_story[theme.id] = theme.user_stories.select { |user_story| user_story.status == "unnasigned" }
			@mvp_themes[theme.id] = UserStory.gethighestpriority(@theme_user_story[theme.id])
		end

		@mvp_epics = Hash.new
		@epic_user_story = Hash.new
		@epics = @project.epics.select { |epic| epic.status == "active" }
		@epics.each do |epic|
			@epic_user_story[epic.id] = epic.user_stories.select { |user_story| user_story.status == "unnasigned" }
			@mvp_epics[epic.id] = UserStory.gethighestpriority(@epic_user_story[epic.id])
		end
		icebox_user_stories = @product_backlog.user_stories.where(:epic_id => nil).where(:theme_id => nil)
		@icebox_user_stories = icebox_user_stories.select { |user_story| user_story.status == "unnasigned" }
		@mvp_user_story = UserStory.gethighestpriority(@product_backlog.user_stories)
		
		flash[:notice] = "User story destroyed"

    redirect_back(fallback_location: projects_path)
	end

	private

		def set_user_story_and_product_backlog
      @user_story = UserStory.find(params[:id])
			@product_backlog = ProductBacklog.find(@user_story.product_backlog_id)
			@project = @product_backlog.project
		end

		def user_story_params
    params.require(:user_story).permit(:name, :description, :effort, :priority, 
    	:product_backlog_id, :sprint_backlog_id, :epic_id, :theme_id, :acceptance_condition, documents_files: [])
    end
end
