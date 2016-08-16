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

class User < ApplicationRecord
  resourcify
  rolify

  # Refile's way of saying: I will manage this 'image'
  attachment :image, type: :image
  
  validates :first_name, :last_name, :encrypted_password, presence: true, length: {minimum: 2}#, if: :confirmed_account? 
  validates :password, confirmation: true
  validates :email, email_format: { message: "Please enter a valid email" }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :invitable, :lastseenable

  has_and_belongs_to_many :teams
  has_many :team_invitations_as_sender, :class_name => 'TeamInvitation', :foreign_key => 'sender_id'
  has_many :team_invitations_as_receiver, :class_name => 'TeamInvitation', :foreign_key => 'receiver_id'
  has_many :user_stories

  # actioncable
  has_many :messages, dependent: :destroy

  # has_one :team_ownership, :class_name => 'Team', :foreign_key => 'owner_id'

  def send_devise_notification(notification, *args)
	  devise_mailer.send(notification, self, *args).deliver_later
	end

  # def confirmed_account?
  #   !confirmed_at.nil?
  # end

  def name
    [first_name, last_name].join(' ')
  end

  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

end
