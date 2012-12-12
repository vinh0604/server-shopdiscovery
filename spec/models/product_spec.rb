require 'spec_helper'

describe Product do
  before(:each) do
    @product = Product.new
  end

  it "has a category" do
    @product.should respond_to :category
  end

  it "has many shop products" do
    @product.should respond_to :shop_products
  end

  it "accepts a Hash for specifics attributes" do
    expect{ @product.specifics = {} }.to_not raise_error
  end
end
