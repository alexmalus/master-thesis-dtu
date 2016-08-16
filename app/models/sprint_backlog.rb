# == Schema Information
#
# Table name: sprint_backlogs
#
#  id         :integer          not null, primary key
#  sprint_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SprintBacklog < ApplicationRecord
	belongs_to :sprint
	has_many :user_stories
	validates :sprint_id, presence: true
end
