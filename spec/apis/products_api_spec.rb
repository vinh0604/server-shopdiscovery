require 'spec_helper'

describe "Products" do
  describe "GET /api/v1/products" do
    before(:each) do
      @sub_category = FactoryGirl.create(:sub_category)
      @product = FactoryGirl.create(:product)
      @shop_product = FactoryGirl.build(:shop_product) do |sp|
        sp.product = @product
      end
      @shop_product.save
    end
    it "returns status 200 with products data" do
      get 'api/v1/products'
      response.status.should == 200
      Rails.logger.debug response.body
      data = JSON.parse response.body
      data.should have_key 'total'
      data.should have_key 'offset'
      data.should have_key 'products'
      data['products'].first['product']['id'].should == @product.id
    end
  end

  describe "GET /api/v1/products/:product_id" do
    before(:each) do
      @product = FactoryGirl.create(:product)
    end
    it "returns status 200 with product data if product found" do
      get "api/v1/products/#{@product.id}"
      response.status.should == 200
      data = JSON.parse response.body
      data['id'].should == @product.id
    end
    it "returns status 500 if product not found" do
      get "api/v1/products/#{@product.id} + 1"
      response.status.should == 500
    end
  end

  describe "GET /api/v1/products/barcode/:ean" do
    before(:each) do
      @product = FactoryGirl.create(:product)
    end
    it "returns status 200 with product data if found a product with provided barcode" do
      get "api/v1/products/barcode/#{@product.barcode}"
      response.status.should == 200
      data = JSON.parse response.body
      data['id'].should == @product.id
    end
    it "returns status 200 with empty hash if not found product with provided barcode" do
      get "api/v1/products/barcode/0000000000000"
      response.status.should == 200
      response.body.should == {}.to_json
    end
  end

  describe "GET /api/v1/categories" do
    before(:each) do
      @sub_category = FactoryGirl.create(:sub_category)
      @category = @sub_category.parent
    end
    it "returns status 200 with all first-level categories if params[:parent_id] not provided" do
      get 'api/v1/categories'
      data = JSON.parse response.body
      data.length.should == 1
      data[0]['id'].should == @category.id
    end
    it "returns status 200 with sub-categories of the categories which id equal params[:parent_id]" do
      get 'api/v1/categories', {:parent_id => @category.id}
      response.status.should == 200
      data = JSON.parse response.body
      data.length.should == 1
      data[0]['id'].should == @sub_category.id
    end
  end

  describe "GET /api/v1/categories/list" do
    before(:each) do
      @sub_category = FactoryGirl.create(:sub_category)
      @category = @sub_category.parent
    end
    it "returns status 200 with all first-level categories if params[:category_id] not provided" do
      get 'api/v1/categories/list'
      response.status.should == 200
      data = JSON.parse response.body
      data.should have_key 'children'
      data['children'].first['id'] = @category.id
    end
    it "returns status 200 with category, parent, children data if params[:category_id] provided" do
      get 'api/v1/categories/list', {:category_id => @sub_category.id}
      response.status.should == 200
      data = JSON.parse response.body
      data.should have_key 'category'
      data.should have_key 'parent'
      data.should have_key 'children'
      data['category']['id'] = @sub_category.id
    end
  end
end