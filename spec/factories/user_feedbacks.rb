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

FactoryGirl.define do
  factory :user_feedback do
    
  end
end
