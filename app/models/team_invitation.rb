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

class TeamInvitation < ApplicationRecord
	belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
	belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
	belongs_to :team

  validates :sender_id, :receiver_id, :team_id, :is_active, presence: true

end
