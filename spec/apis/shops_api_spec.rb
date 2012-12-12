require 'spec_helper'

describe "Shops" do
  describe "GET /api/v1/shops" do
    before(:each) do
      @shop = FactoryGirl.create(:shop)
    end

    it "returns status 200 with all shops data" do
      get 'api/v1/shops'
      response.status.should == 200
      data = JSON.parse response.body
      data.should have_key 'shops'
      data.should have_key 'total'
      data.should have_key 'offset'
      data['shops'].should be_instance_of(Array)
      data['shops'].length.should == 1
    end

    it "returns status 200 with all shops which name or tags contain params[:keyword" do
      get 'api/v1/shops', {:keyword => @shop.name.mb_chars.downcase}
      response.status.should == 200
      data = JSON.parse response.body
      data['shops'].length.should == 1
      data['shops'].first['shop']['id'].should == @shop.id
    end
  end

  describe "GET /api/v1/shops/:id" do
    before(:each) do
      @shop = FactoryGirl.create(:shop)
    end

    it "returns status 200 if the shop exists" do
      get "api/v1/shops/#{@shop.id}"
      response.status.should == 200
      data = JSON.parse response.body
      data['id'].should == @shop.id
      data['name'].should == @shop.name
    end

    it "returns status 500 if the shop not exists" do
      get "api/v1/shops/1"
      response.status.should == 500
    end
  end

  context "Shop's categories" do
    before(:each) do
      @shop = FactoryGirl.create(:shop)
      @sub_category = FactoryGirl.create(:sub_category)
      @product = FactoryGirl.build(:product) do |p|
        p.category = @sub_category
      end
      @product.save
      @shop_product = FactoryGirl.build(:shop_product) do |sp|
        sp.product = @product
        sp.shop = @shop
      end
      @shop_product.save
    end

    describe "GET /api/v1/shops/:id/categories" do
      it "returns status 200 with first level categories of shop if params[:parent_id] not provided" do
        get "api/v1/shops/#{@shop.id}/categories"
        response.status.should == 200
        response.body.should == [@sub_category.parent].to_json(:methods => :has_children?)
      end
      it "returns status 200 with sub categories of category with params[:parent_id] of shop" do
        get "api/v1/shops/#{@shop.id}/categories", {:parent_id => @sub_category.parent.id}
        response.status.should == 200
        response.body.should == [@sub_category].to_json(:methods => :has_children?)
      end
    end
  end
end