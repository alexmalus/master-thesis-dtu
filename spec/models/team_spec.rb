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

require 'rails_helper'

RSpec.describe Team, type: :model do
  it "is valid with name, description" do
  	team = Team.new(
  		name: "Saving Nemo",
  		description: "a fine example of a description"
  	)
  	expect(team).to be_valid
  end
  it "is invalid with too short name" do
  	team = Team.new(
  		name: "a",
  		description: "I saved Nemo, what now?"
  	)
  	team.valid?
  	expect(team.errors[:name]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid with too short description" do
  	team = Team.new(
  		name: "Help",
  		description: "h"
  	)
  	team.valid?
  	expect(team.errors[:description]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid without name" do
  	team = Team.new(
	  	description: "a fine example of a description"
  	)
  	team.valid?
  	expect(team.errors[:name]).to include("can't be blank")
  end
  it "is invalid without description" do
  	team = Team.new(
	  	name: "Hello"
  	)
  	team.valid?
  	expect(team.errors[:description]).to include("can't be blank")
  end
end