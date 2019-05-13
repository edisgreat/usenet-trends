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

require "rails_helper"

describe Request, type: :model do

  context "valid Factory" do
    it "has a valid factory" do
      expect(build(:request)).to be_valid
    end
  end

  context "associations" do
    it { should have_many :results }
  end

  context "post save" do
    it "creates results" do
      expect(create(:request).results.count).to be_positive
    end
  end
  
end
