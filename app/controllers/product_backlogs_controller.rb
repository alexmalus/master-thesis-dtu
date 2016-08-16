# == Schema Information
#
# Table name: product_backlogs
#
#  id         :integer          not null, primary key
#  category   :string
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductBacklogsController < ApplicationController
	# Once again note that, for models that are named differently, this method will have a different name (authenticate_admin! for Admin model).
	before_action :authenticate_user!
  before_action :set_project, only: [:show]

	def show
    if @project.product_backlog
			@product_backlog = @project.product_backlog
		else
			@product_backlog = ProductBacklog.new
			@product_backlog.save!
			@project.product_backlog = @product_backlog
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
	end

	def close_popup
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
end
