# == Schema Information
#
# Table name: sprints
#
#  id               :integer          not null, primary key
#  release_id       :integer
#  project_id       :integer
#  name             :string
#  status           :integer          default("created")
#  committed_effort :integer
#  done_effort      :integer
#  start_date       :datetime
#  release_date     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :sprint do
    
  end
end
