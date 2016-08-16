# == Schema Information
#
# Table name: chatrooms
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chatroom < ActiveRecord::Base
  belongs_to :team
  has_many :messages, dependent: :destroy
  validates :title, presence: true, uniqueness: true, case_sensitive: false
  before_validation :sanitize, :slugify

  def to_param
    self.slug
  end

  def slugify
    self.slug = self.title.downcase.gsub(" ", "-")
  end

  def sanitize
    self.title = self.title.strip
  end
end
