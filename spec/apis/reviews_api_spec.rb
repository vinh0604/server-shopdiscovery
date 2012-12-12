require 'spec_helper'

describe "Reviews" do
  before(:each) do
    @shop = FactoryGirl.create(:shop)
    @review = FactoryGirl.build(:review) do |r|
      r.reviewable = @shop
      r.reviewer = FactoryGirl.create(:user)
    end
    @review.save
  end

  describe "GET /api/v1/reviews/:reviewable_id" do
    it "returns status 200 with all reviews of the reviewable object" do
      get "api/v1/reviews/#{@shop.id}", {:reviewable_type => 'shop'}
      response.status.should == 200
      data = JSON.parse response.body
      data['reviews'].should be_instance_of(Array)
      data['reviews'].length.should == 1
      data['reviews'].first['review']['id'].should == @review.id
    end

    it "returns status 500 if the reviewable object not found" do
      get "api/v1/reviews/#{@shop.id + 1}", {:reviewable_type => 'shop'}
      response.status.should == 500
    end
  end

  describe "GET /api/v1/reviews/:reviewable_id/summary" do
    it "returns status 200 with review statistic of the reviewable object" do
      get "api/v1/reviews/#{@shop.id}/summary", {:reviewable_type => 'shop'}
      response.status.should == 200
      Rails.logger.debug response.body
      data = JSON.parse response.body
      data.should have_key @review.rating.to_s
      data[@review.rating.to_s].should == 1
    end

    it "returns status 500 if the reviewable object not found" do
      get "api/v1/reviews/#{@shop.id + 1}/summary", {:reviewable_type => 'shop'}
      response.status.should == 500
    end
  end

  describe "POST /api/v1/reviews" do
    it "must be authenticated"

    it "must have params[:rating], params[:reviewable_type], params[:reviewable_id]"

    it "returns status 201 if new review is created"
  end
end