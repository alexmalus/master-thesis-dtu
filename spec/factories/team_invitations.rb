# == Schema Information
#
# Table name: team_invitations
#
#  id          :integer          not null, primary key
#  is_active   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :integer
#  sender_id   :integer
#  receiver_id :integer
#

FactoryGirl.define do
  factory :team_invitation do
    
  end
end
