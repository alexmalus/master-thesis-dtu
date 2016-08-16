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

FactoryGirl.define do
  factory :product_backlog do
    category ""
  end
end
