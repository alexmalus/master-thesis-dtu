# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  project_id        :integer
#  sprint_id         :integer
#  release_id        :integer
#  user_story_id     :integer
#  file_id           :string           not null
#  file_filename     :string           not null
#  file_size         :string           not null
#  file_content_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Document < ActiveRecord::Base
  belongs_to :project
	belongs_to :sprint
	belongs_to :release
	belongs_to :user_story

  attachment :file
end
