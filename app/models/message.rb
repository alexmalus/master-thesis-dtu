# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  chatroom_id :integer
#  user_id     :integer
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Message < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :user

  validates :content, presence: true, length: {minimum: 2, maximum: 500 }

  # after_commit { CommentRelayJob.perform_later(self) }
end
