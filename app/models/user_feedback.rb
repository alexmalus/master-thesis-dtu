# == Schema Information
#
# Table name: user_feedbacks
#
#  id           :integer          not null, primary key
#  name         :string
#  contact_info :string
#  description  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserFeedback < ApplicationRecord
	validates :name, :contact_info, :description, presence: true, length: {minimum: 2, maximum: 500}
end