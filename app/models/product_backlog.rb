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

class ProductBacklog < ApplicationRecord
	belongs_to :project
	has_many :user_stories, dependent: :destroy
end
