require 'spec_helper'

describe "Reviews" do
  before(:each) do
    @shop = FactoryGirl.create(:shop)
    @user = FactoryGirl.create(:user)
    @review = FactoryGirl.build(:review) do |r|
      r.reviewable = @shop
      r.reviewer = @user
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
      data['star_count'].should have_key @review.rating.to_s
      data['star_count'][@review.rating.to_s].should == 1
    end

    it "returns status 500 if the reviewable object not found" do
      get "api/v1/reviews/#{@shop.id + 1}/summary", {:reviewable_type => 'shop'}
      response.status.should == 500
    end
  end

  describe "POST /api/v1/reviews" do
    before(:each) do
      @shop_product = FactoryGirl.create(:shop_product)
      @params = {
        :reviewable_id => @shop_product.id,
        :reviewable_type => 'shop_product',
        :rating => 5,
        :auth_token => @user.authentication_token
      }
    end
    it "must have params[:rating], params[:reviewable_type], params[:reviewable_id]" do
      post 'api/v1/reviews'
      response.status.should == 400
    end

    it "must be authenticated" do
      post 'api/v1/reviews', @params.reject{|k| k==:auth_token}
      response.status.should == 401
    end

    it "returns status 500 if reviewable not found" do
      @params[:reviewable_id] = 0
      post 'api/v1/reviews', @params
      response.status.should == 500
    end

    it "returns status 201 if new review is created" do
      post 'api/v1/reviews', @params
      response.status.should == 201
    end
  end
end