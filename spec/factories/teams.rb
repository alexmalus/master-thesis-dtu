# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :integer
#

FactoryGirl.define do
  factory :team do
    name "MyString"
    description "MyString"
  end
end
