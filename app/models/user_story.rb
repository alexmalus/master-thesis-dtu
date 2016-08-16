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

class UserStory < ApplicationRecord
	belongs_to :product_backlog
	belongs_to :epic
	belongs_to :theme
	belongs_to :sprint_backlog
	belongs_to :user
	has_many :documents
	has_many :tasks
	accepts_attachments_for :documents, append: true

  validates :name, :description, presence: true, length: {minimum: 2}
	validates :priority, numericality: true

	scope :belongs_user_and_project, ->(product_backlog_id, user_id) { where("product_backlog_id = ? 
		AND user_id = ?", product_backlog_id, user_id) }

	enum status: [ :unnasigned, :assigned, :started, :to_be_reviewed, :to_be_validated, :done, :inactive, :integrated, :taken ]
	# status assigned - assigned to the story backlog but not started by a team user
	# status integrated - does not count in graphs. It is assumed that once a user story is integrated,
		# it has been transformed into one or more tasks..these tasks will have their effort placed into the graphs
	# status taken - assigned to a specific user
	
	def self.gethighestpriority(user_stories)
		highest_user_story = UserStory.new
		highest_user_story.priority = 0
		# user_stories = user_stories.select { |user_story| user_story.status == "created" }
		
		user_stories.each do |user_story|
			if highest_user_story.priority == 0
				highest_user_story = user_story
			elsif user_story.priority <= highest_user_story.priority
				highest_user_story = user_story
			end
		end
		highest_user_story
	end

	def set_inactive
		self.status = :inactive
	end

	# def is_active?
	# 	self.status == "active"
	# end

	def assign
		self.status = :assigned
	end

	def unassign
		self.status = :unnasigned
	end

	def integrate
		self.status = :integrated
	end

	def take
		self.status = :taken
	end 
end
