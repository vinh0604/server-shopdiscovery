require 'spec_helper'

describe "Suggestions" do
  before(:each) do
    @product = FactoryGirl.create(:product)
  end
  describe "GET /api/v1/suggestions/products" do
    it "return status 200 with product data match with params[:keyword]" do
      get 'api/v1/suggestions/products', {:keyword => @product.name}
      response.status.should == 200
      data = JSON.parse response.body
      data.should be_instance_of(Array)
      data.length.should == 1
      data.first['id'].should == @product.id
    end
  end
end