# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  student_number         :string
#  phone_number           :string
#  skype                  :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  image_id               :string
#  image_filename         :string
#  image_size             :integer
#  image_content_type     :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  invited_on_team_id     :integer
#  last_seen              :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with first_name, last_name, email and password" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex@testplace.com"
  	)
  	expect(user).to be_valid
  end
  it "is invalid without first_name" do
  	user = User.new(
  		first_name: nil,
  		last_name: "Dongo",
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:first_name]).to include("can't be blank")
  end
  it "is invalid without last_name" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: nil,
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:last_name]).to include("can't be blank")	
  end
  it "is invalid without email" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		email: nil,
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  	)
  	user.valid?
  	expect(user.errors[:email]).to include("can't be blank")	
  end
  it "is invalid without password" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		encrypted_password: nil,
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:encrypted_password]).to include("can't be blank")	
  end
  it "is invalid with different password confirmation" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		password: "ArandomPass",
  		password_confirmation: "NotTheOneYoureLookingFor",
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:password_confirmation]).to include("doesn't match Password")	
  end
  it "is invalid with a duplicate email address" do
  	User.create(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex@testplace.com"
  	)
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:email]).to include("has already been taken")
  end
  it "is invalid with too short first_name" do
  	user = User.new(
  		first_name: "M",
  		last_name: "Dongo",
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:first_name]).to include("is too short (minimum is 2 characters)")	
  end
  it "is invalid with too short last_name" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "D",
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:last_name]).to include("is too short (minimum is 2 characters)")	
  end
  it "is invalid with too short password" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		password: "Pass",
  		password_confirmation: "Pass",
  		email: "alex@testplace.com"
  	)
  	user.valid?
  	expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")	
  end
  it "is invalid with malformed email" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo",
  		password: "ArandomPass",
  		password_confirmation: "ArandomPass",
  		email: "alex.com"
  	)
  	user.valid?
  	expect(user.errors[:email]).to include("Please enter a valid email")
  end
  it "returns a user's full name as a string" do
  	user = User.new(
  		first_name: "Mongo",
  		last_name: "Dongo"
  	)
  	expect(user.name).to eq 'Mongo Dongo'
  end
end
