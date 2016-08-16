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

require 'rails_helper'

RSpec.describe TeamInvitation, type: :model do
  it "is valid with sender, receiver, team and active check" do
  	team_invitation = TeamInvitation.new(
  		is_active: true,
  		sender_id: 1,
  		receiver_id: 2,
  		team_id: 3
  	)
  	expect(team_invitation).to be_valid
  end
  it "is invalid without is_active" do
  	team_invitation = TeamInvitation.new(
  		sender_id: 1,
  		receiver_id: 2,
  		team_id: 3
  	)
  	team_invitation.valid?
  	expect(team_invitation.errors[:is_active]).to include("can't be blank")
  end
  it "is invalid without sender" do
  	team_invitation = TeamInvitation.new(
  		is_active: true,
  		receiver_id: 2,
  		team_id: 3
  	)
  	team_invitation.valid?
  	expect(team_invitation.errors[:sender_id]).to include("can't be blank")
  end
  it "is invalid without receiver" do
  	team_invitation = TeamInvitation.new(
	  	is_active: true,
  		sender_id: 1,
  		team_id: 3
  	)
  	team_invitation.valid?
  	expect(team_invitation.errors[:receiver_id]).to include("can't be blank")
  end
  it "is invalid without team" do
  	team_invitation = TeamInvitation.new(
	  	is_active: true,
  		sender_id: 1,
  		receiver_id: 2,
  	)
  	team_invitation.valid?
  	expect(team_invitation.errors[:team_id]).to include("can't be blank")
  end
end