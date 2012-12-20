require 'spec_helper'

describe "Search" do
  describe "GET /api/v1/search" do
    before(:each) do
      @category = FactoryGirl.create(:sub_category)
      @shop = FactoryGirl.create(:shop)
      @product = FactoryGirl.build(:product) do |p|
        p.category = @category
      end
      @product.save
      @shop_product = FactoryGirl.build(:shop_product) do |sp|
        sp.product = @product
        sp.shop = @shop
      end
      @shop_product.save
    end

    it "returns status 200 with result data" do
      get 'api/v1/search', :keyword => @product.name
      response.status.should == 200
      data = JSON.parse response.body
      data.should have_key 'total'
      data.should have_key 'offset'
      data.should have_key 'shop_products'
      data['shop_products'].length.should == 1
      data['shop_products'].first['shop_product']['id'].should == @shop_product.id
    end
  end
end