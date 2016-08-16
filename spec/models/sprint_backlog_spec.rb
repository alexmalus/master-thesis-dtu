# == Schema Information
#
# Table name: sprint_backlogs
#
#  id         :integer          not null, primary key
#  sprint_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SprintBacklog, type: :model do
  it "is valid with sprint id" do
  	sprint_backlog = SprintBacklog.new(
  		sprint_id: 5
  	)
  	expect(sprint_backlog).to be_valid
  end
  it "is invalid without a sprint id" do
  	sprint_backlog = SprintBacklog.new
  	sprint_backlog.valid?
  	expect(sprint_backlog.errors[:sprint_id]).to include("can't be blank")
  end
end
