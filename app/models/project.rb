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

class Project < ApplicationRecord
	resourcify
	
	validates :name, :description, presence: true, length: {minimum: 2}
	validates :def_sprint_dur, numericality: true

	belongs_to :team
	has_one :product_backlog, dependent: :destroy
	has_one :sprint_backlog, dependent: :destroy
	has_many :epics, dependent: :destroy
	has_many :themes, dependent: :destroy
	has_many :releases, dependent: :destroy
	has_many :sprints, dependent: :destroy
	has_many :retrospectives, dependent: :destroy
  attachment :image, type: :image
	has_many :documents
	accepts_attachments_for :documents, append: true

	before_create :set_active

	def set_active
		self.active = true
	end

	def set_inactive
		self.active = false
	end

	def is_active?
		self.active == true
	end

	def is_inactive?
		self.active == false
	end

	def commit_work
		self.product_backlog.user_stories.each do |user_story|
			if user_story.status == "unnasigned" || user_story.status == "assigned" ||
				user_story.status == "taken"
				self.committed_work += user_story.effort
			end
		end
		self.save!
	end
	
end
