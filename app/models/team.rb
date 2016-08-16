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

class Team < ApplicationRecord
	resourcify

	has_and_belongs_to_many :users
	has_many :projects
	has_many :team_invitations, dependent: :destroy

	# actioncable
  has_many :chatrooms, dependent: :destroy

  validates :name, :description, presence: true, length: {minimum: 2}

	# another table team_owner?
	# belongs_to :owner, :class => "User", :foreign_key => "owner_id"
end
