# == Schema Information
#
# Table name: tasks
#
#  id                :integer          not null, primary key
#  description       :string
#  estimation        :integer
#  status            :integer          default("created")
#  sprint_backlog_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :task do
    description "MyString"
    estimation 1
  end
end
