# == Schema Information
#
# Table name: results
#
#  id              :bigint(8)        not null, primary key
#  start_date      :date
#  end_date        :date
#  amount          :integer
#  precision       :string
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  request_id      :bigint(8)
#  debug_payload   :text
#  debug_result    :text
#  result_month_id :integer
#

require "rails_helper"

describe Result, type: :model do

  context "valid Factory" do
    it "has a valid factory" do
      expect(build(:result)).to be_valid
    end
  end

  context "associations" do
    it { should belong_to :request }
  end
  
end
