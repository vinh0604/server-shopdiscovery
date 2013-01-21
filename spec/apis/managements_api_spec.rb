require 'spec_helper'

describe "Managements" do
  before(:each) do
    
  end
  context "Shops" do
    before(:each) do
      @shop = FactoryGirl.create(:shop)
      @user = FactoryGirl.create(:user)
      @manager = FactoryGirl.build(:manager) do |m|
        m.shop = @shop
        m.user = @user
      end
      @manager.save
    end
    describe "GET /api/v1/managements/shops" do
      it "returns status 200 with all shops where user is manager" do
        get 'api/v1/managements/shops', {:auth_token => @user.authentication_token}
        response.status.should == 200
        data = JSON.parse response.body
        data.should have_key 'shops'
        data['shops'].should be_instance_of(Array)
        data['shops'].first['shop']['id'].should == @shop.id
      end
      it "returns status 401 if authentication failed" do
        get 'api/v1/managements/shops', {:auth_token => ''}
        response.status.should == 401
      end
    end

    describe "GET /api/v1/managements/shops/:shop_id" do
      it "returns status 200 with shop data" do
        get "api/v1/managements/shops/#{@shop.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
        data = JSON.parse response.body
        data['id'].should == @shop.id
      end
      it "returns status 401 if authentication failed" do
        get "api/v1/managements/shops/#{@shop.id}", {:auth_token => ''}
        response.status.should == 401
      end
    end

    describe "POST /api/v1/managements/shops" do
      it "returns status 201 with shop data" do
        name = 'Sample name'
        post "api/v1/managements/shops", {:auth_token => @user.authentication_token, :name => name}
        response.status.should == 201
        data = JSON.parse response.body
        data['id'].should_not be_blank
        new_shop = Shop.find(data['id'])
        new_shop.managers.first.user_id == @user.id
      end
      it "returns status 401 if authentication failed" do
        post "api/v1/managements/shops", {:auth_token => '', :name => ''}
        response.status.should == 401
      end
    end

    describe "PUT /api/v1/managements/shops/:shop_id" do
      it "returns status 200 with shop data" do
        name = 'Sample name'
        put "api/v1/managements/shops/#{@shop.id}", {:auth_token => @user.authentication_token, :name => name}
        response.status.should == 200
        @shop.reload
        @shop.name.should == name
      end
      it "returns status 401 if authentication failed" do
        put "api/v1/managements/shops/#{@shop.id}", {:auth_token => ''}
        response.status.should == 401
      end
    end

    describe "DELETE /api/v1/managements/shops/:shop_id" do
      it "returns status 200 if shop is successfully deleted" do
        delete "api/v1/managements/shops/#{@shop.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
        Shop.find_by_id(@shop.id).should be(nil)
      end
      it "returns status 401 if authentication failed" do
        delete "api/v1/managements/shops/#{@shop.id}", {:auth_token => ''}
        response.status.should == 401
      end
    end
  end

  context "ShopProducts" do
    describe "GET /api/v1/managements/shop_products/check" do
      it "returns status 200 with shop product data if product exists in shop"
      it "returns status 200 with plain hash if product not exists in shop"
    end
  end

  context "Photos" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    describe "POST /api/v1/photos" do
      it "returns status 201 with photo if successfully saved" do
        @file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user.png'), 'image/png')
        post "api/v1/photos", {:auth_token => @user.authentication_token, :image => @file}
        response.status.should == 201
        data = JSON.parse response.body
        data['id'].should_not be_blank
        data['image']['url'].should_not be_blank
      end
      it "returns status 401 if authentication failed" do
        @file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user.png'), 'image/png')
        post "api/v1/photos", {:auth_token => '', :image => @file}
        response.status.should == 401
      end
    end 
  end
end