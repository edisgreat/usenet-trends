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