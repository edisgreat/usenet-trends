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