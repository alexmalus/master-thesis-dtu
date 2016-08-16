# == Schema Information
#
# Table name: sprint_backlogs
#
#  id         :integer          not null, primary key
#  sprint_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SprintBacklogsController < ApplicationController
	before_action :authenticate_user!
  
end
