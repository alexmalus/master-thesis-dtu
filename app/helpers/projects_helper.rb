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

module ProjectsHelper
end
