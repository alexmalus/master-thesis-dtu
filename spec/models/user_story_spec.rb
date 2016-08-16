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

require 'rails_helper'

RSpec.describe UserStory, type: :model do
  it "is valid with name, description" do
  	user_story = UserStory.new(
  		name: "Saving Nemo",
  		description: "a fine example of a description",
  		priority: 5
  	)
  	expect(user_story).to be_valid
  end
  it "is invalid with too short name" do
  	user_story = UserStory.new(
  		name: "a",
  		description: "I saved Nemo, what now?",
  		priority: 5
  	)
  	user_story.valid?
  	expect(user_story.errors[:name]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid with too short description" do
  	user_story = UserStory.new(
  		name: "Help",
  		description: "h",
  		priority: 5
  	)
  	user_story.valid?
  	expect(user_story.errors[:description]).to include("is too short (minimum is 2 characters)")
  end
  it "is invalid without name" do
  	user_story = UserStory.new(
	  	description: "a fine example of a description",
	  	priority: 5
  	)
  	user_story.valid?
  	expect(user_story.errors[:name]).to include("can't be blank")
  end
  it "is invalid without description" do
  	user_story = UserStory.new(
	  	name: "Hello",
	  	priority: 5
  	)
  	user_story.valid?
  	expect(user_story.errors[:description]).to include("can't be blank")
  end
  it "is invalid with priority different than a number type" do
  	user_story = UserStory.new(
  		name: "Hello",
  		description: "Can you hear me?",
  		priority: "Adele - Hello"
  	)
  	user_story.valid?
  	expect(user_story.errors[:priority]).to include("is not a number")
  end
end