# == Schema Information
#
# Table name: releases
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  status      :integer          default("done")
#  project_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Release < ApplicationRecord
	belongs_to :project
	has_one :sprint
	has_many :documents
	accepts_attachments_for :documents, append: true

  validates :name, :description, :status, presence: true, length: {minimum: 2}

	enum status: [ :done, :cancelled ]
end
