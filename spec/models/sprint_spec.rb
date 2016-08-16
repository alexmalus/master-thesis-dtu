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

require 'rails_helper'

RSpec.describe Sprint, type: :model do
	datetime = DateTime.new
  it "is valid with name, status, start_date, release_date" do
  	sprint = Sprint.new(
  		name: "Saving Nemo",
  		status: 1,
  		start_date: datetime,
  		release_date: datetime
  	)
  	expect(sprint).to be_valid
  end
  it "is invalid with too short name" do
  	sprint = Sprint.new(
  		name: "S",
  		status: 1,
  		start_date: datetime,
  		release_date: datetime
  	)
  	sprint.valid?
  	expect(sprint.errors[:name]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid with invalid start_date data" do
  	sprint = Sprint.new(
  		name: "Help",
  		status: 1,
  		start_date: "xx",
  		release_date: datetime
  	)
  	sprint.valid?
  	expect(sprint.errors[:start_date]).to include("can't be blank")
  end
  it "is invalid with invalid release_date data" do
  	sprint = Sprint.new(
  		name: "Help",
  		status: 1,
  		start_date: datetime,
  		release_date: "xx"
  	)
  	sprint.valid?
  	expect(sprint.errors[:release_date]).to include("can't be blank")
  end
  it "is invalid without name" do
  	sprint = Sprint.new(
	  	status: 1,
  		start_date: datetime,
  		release_date: datetime
  	)
  	sprint.valid?
  	expect(sprint.errors[:name]).to include("can't be blank")
  end
  it "is invalid without start_date" do
  	sprint = Sprint.new(
	  	name: "Help",
	  	status: 1,
  		release_date: datetime
  	)
  	sprint.valid?
  	expect(sprint.errors[:start_date]).to include("can't be blank")
  end
  it "is invalid without release_date" do
  	sprint = Sprint.new(
	  	name: "Help",
	  	status: 1,
  		start_date: datetime,
  	)
  	sprint.valid?
  	expect(sprint.errors[:release_date]).to include("can't be blank")
  end
end