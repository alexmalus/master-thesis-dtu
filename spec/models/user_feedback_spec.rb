# == Schema Information
#
# Table name: user_feedbacks
#
#  id           :integer          not null, primary key
#  name         :string
#  contact_info :string
#  description  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe UserFeedback, type: :model do
  it "is valid with name, description" do
  	user_feedback = UserFeedback.new(
  		name: "Saving Nemo",
  		contact_info: "visit me at ..",
  		description: "a fine example of a description"
  	)
  	expect(user_feedback).to be_valid
  end
  it "is invalid with too short name" do
  	user_feedback = UserFeedback.new(
  		name: "S",
  		contact_info: "visit me at ..",
  		description: "a fine example of a description"
  	)
  	user_feedback.valid?
  	expect(user_feedback.errors[:name]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid with too short description" do
  	user_feedback = UserFeedback.new(
  		name: "Saving Nemo",
  		contact_info: "visit me at ..",
  		description: "a"
  	)
  	user_feedback.valid?
  	expect(user_feedback.errors[:description]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid with too short contact_info" do
  	user_feedback = UserFeedback.new(
  		name: "Saving Nemo",
  		contact_info: "v",
  		description: "a fine example of a description"
  	)
  	user_feedback.valid?
  	expect(user_feedback.errors[:contact_info]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid without name" do
  	user_feedback = UserFeedback.new(
  		contact_info: "visit me at ..",
  		description: "a fine example of a description"
  	)
  	user_feedback.valid?
  	expect(user_feedback.errors[:name]).to include("can't be blank")
  end
  it "is invalid without description" do
  	user_feedback = UserFeedback.new(
	  	name: "Saving Nemo",
  		contact_info: "visit me at .."
  	)
  	user_feedback.valid?
  	expect(user_feedback.errors[:description]).to include("can't be blank")
  end
  it "is invalid without contact_info" do
  	user_feedback = UserFeedback.new(
	  	name: "Saving Nemo",
  		description: "a fine example of a description"
  	)
  	user_feedback.valid?
  	expect(user_feedback.errors[:contact_info]).to include("can't be blank")
  end
end