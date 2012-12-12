require 'spec_helper'

describe "ShopProducts" do
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

  describe "GET /api/v1/shop_products" do
    context "params[:product_id] provided" do
      it "returns status 200 with shop products of specific product" do
        get 'api/v1/shop_products', {:product_id => @product.id}
        response.status.should == 200
        data = JSON.parse response.body
        data.should have_key 'shop_products'
        data['shop_products'].length.should == 1
        data['shop_products'].first['shop_product']['id'].should == @shop_product.id
      end
    end

    context "params[:shop_id] and params[:category_id] provided" do
      it "returns status 200 with shop products of specific shop and category when params[:category_id] provided" do
        get 'api/v1/shop_products', {:shop_id => @shop.id, :category_id => @sub_category.id}
        response.status.should == 200
        data = JSON.parse response.body
        data.should have_key 'shop_products'
        data['shop_products'].length.should == 1
        data['shop_products'].first['shop_product']['id'].should == @shop_product.id
      end
    end
  end

  describe "GET /api/v1/shop_products/:id" do
    it "returns status 200 with the shop product data" do
      get "api/v1/shop_products/#{@shop_product.id}"
      response.status.should == 200
      data = JSON.parse response.body
      data.should have_key 'product'
      data.should have_key 'shop'
      data.should have_key 'photos'
      data['product'].should have_key 'category'
    end
  end
end