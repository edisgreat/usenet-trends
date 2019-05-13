# == Schema Information
#
# Table name: requests
#
#  id           :bigint(8)        not null, primary key
#  start_date   :date
#  end_date     :date
#  query        :string
#  cookie       :string
#  author_email :string
#  author_name  :string
#  source_type  :string
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  authstring   :string
#

require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
