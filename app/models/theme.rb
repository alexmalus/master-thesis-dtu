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

class Theme < ApplicationRecord
	belongs_to :project
	has_many :user_stories

  validates :name, :description, :status, presence: true, length: {minimum: 2}

	def set_active
		self.status = "active"
	end

	def set_inactive
		self.status = "inactive"
	end

	def is_active?
		self.status == "active"
	end

	def is_inactive?
		self.status == "inactive"
	end
end
