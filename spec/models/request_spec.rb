require "rails_helper"

RSpec.describe Request, :type => :model do
  
  before(:all) do
    @request = create(:request)
  end

  it "is valid with valid attributes" do
    expect(@request).to be_valid
  end
  
end