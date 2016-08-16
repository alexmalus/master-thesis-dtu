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

class Sprint < ApplicationRecord
	belongs_to :release
	belongs_to :project
	has_one :sprint_backlog, dependent: :destroy
	has_many :documents
	has_one :sprint_done_work
	has_one :retrospective
	accepts_attachments_for :documents, append: true

  validates :name, presence: true, length: {minimum: 2}
  validates :status, :start_date, :release_date, presence: true

	enum status: [ :created, :started, :done, :cancelled ]

	scope :started, ->(project_id) { where("project_id = ? AND status = ?", project_id, 1) }

	def is_started?
		self.status == "started"
	end

	def done
		self.status = :done
	end

	def is_done?
		self.status == "done"
	end

	def cancel
		self.status = :cancelled
	end
end
