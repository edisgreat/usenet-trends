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

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
