# == Schema Information
#
# Table name: user_stories
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :string
#  acceptance_condition :string
#  priority             :integer
#  effort               :integer
#  status               :integer          default("unnasigned")
#  is_task              :boolean          default(FALSE)
#  finished_date        :datetime
#  product_backlog_id   :integer
#  sprint_backlog_id    :integer
#  epic_id              :integer
#  theme_id             :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :user_story do
    description "MyString"
    notes "MyString"
    priority 1
    status "MyString"
  end
end
