# == Schema Information
#
# Table name: sprint_done_works
#
#  id             :integer          not null, primary key
#  sprint_id      :integer
#  project_id     :integer
#  committed_work :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class SprintDoneWork < ApplicationRecord
	belongs_to :sprint

  validates :committed_work, presence: true
end
