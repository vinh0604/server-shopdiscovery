require 'spec_helper'

describe Shop do
  before(:each) do
    @shop = Shop.new
  end

  it "has a creator" do
    @shop.should respond_to :creator
  end

  it "has many products" do
    @shop.should respond_to :shop_products
  end

  it "has many photos" do
    @shop.should respond_to :photos
  end

  it "can have many phone numbers" do
    @shop.phones.should be_instance_of(Array)
  end

  it "has many tags" do
    @shop.should respond_to :tags
  end

  it "has many reviews" do
    @shop.should respond_to(:reviews)
  end

  it "has many favorite shops" do
    @shop.should respond_to(:favorite_shops)
  end
end
