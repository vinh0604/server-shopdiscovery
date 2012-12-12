require 'spec_helper'

describe ShopProduct do
  before(:each) do
    @shop_product = ShopProduct.new
  end

  it "has a shop" do
    @shop_product.should respond_to :shop
  end

  it "has a product" do
    @shop_product.should respond_to :product
  end

  it "has many photos" do
    @shop_product.should respond_to :photos
  end

  it "has many reviews" do
    @shop_product.should respond_to :reviews
  end
end
