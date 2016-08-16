# == Schema Information
#
# Table name: retrospectives
#
#  id                 :integer          not null, primary key
#  name               :string
#  description_good   :string
#  description_bad    :string
#  description_future :string
#  sprint_id          :integer
#  project_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Retrospective < ApplicationRecord
	belongs_to :sprint
	belongs_to :project
	
  validates :name, :description_good, :description_bad, :description_future, presence: true, length: {minimum: 2}
end
