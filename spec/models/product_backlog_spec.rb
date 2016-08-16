# == Schema Information
#
# Table name: product_backlogs
#
#  id         :integer          not null, primary key
#  category   :string
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProductBacklog, type: :model do
  it "is valid with category" do
  	product_backlog = ProductBacklog.new(
  		category: "bug"
  	)
  	expect(product_backlog).to be_valid
  end
  it "is valid without a category" do
  	product_backlog = ProductBacklog.new
  	expect(product_backlog).to be_valid
  end
end
