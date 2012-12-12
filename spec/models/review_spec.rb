require 'spec_helper'

describe Review do
  before(:each) do
    @review = FactoryGirl.build(:review) do |r|
      r.reviewable = FactoryGirl.create(:shop)
      r.reviewer = FactoryGirl.create(:user)
    end
    @review.save
  end
  it "belongs to review" do
    @review.should respond_to(:reviewer)
  end

  it "belongs to a reviewable object" do
    @review.should respond_to(:reviewable)
  end
end
