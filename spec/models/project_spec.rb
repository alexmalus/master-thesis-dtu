# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  team_id               :integer
#  name                  :string
#  description           :string
#  image_id              :string
#  image_filename        :string
#  image_size            :integer
#  image_content_type    :string
#  def_sprint_dur        :integer
#  def_proj_tips         :boolean
#  total_file_limit_size :integer
#  active                :boolean
#  committed_work        :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  it "is valid with name, description, def_sprint_dur, def_proj_tips" do
  	project = Project.new(
  		name: "Mongo",
  		description: "Dongo",
  		def_sprint_dur: 20,
  		def_proj_tips: true
  	)
  	expect(project).to be_valid
  end
  it "is invalid without name" do
  	project = Project.new(
  		name: nil,
  		description: "Dongo",
  		def_sprint_dur: 20,
  		def_proj_tips: true
  	)
  	project.valid?
  	expect(project.errors[:name]).to include("can't be blank")	
  end
  it "is invalid with too short name" do
  	project = Project.new(
  		name: "M",
  		description: "Dongo",
  		def_sprint_dur: 20,
  		def_proj_tips: true
  	)
  	project.valid?
  	expect(project.errors[:name]).to include("is too short (minimum is 2 characters)")	
  end
  it "is invalid without description" do
    project = Project.new(
      name: "Mongo",
      def_sprint_dur: 20,
      def_proj_tips: true
    )
    project.valid?
    expect(project.errors[:description]).to include("can't be blank")  
  end
  it "is invalid with too short description" do
    project = Project.new(
      name: "Mongo",
      description: "D",
      def_sprint_dur: 20,
      def_proj_tips: true,
    )
    project.valid?
    expect(project.errors[:description]).to include("is too short (minimum is 2 characters)")  
  end
end
