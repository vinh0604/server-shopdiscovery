require 'spec_helper'

describe "Favorites" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @shop = FactoryGirl.create(:shop)
    @shop_product = FactoryGirl.create(:shop_product)
  end
  context "favorite shops" do
    describe "GET /api/v1/favorite_shops" do
      before(:each) do
        @favorite_shop = FactoryGirl.build(:favorite_shop) do |fs|
          fs.user = @user
          fs.shop = @shop
        end
        @favorite_shop.save
      end
      it "returns status 200 with all favorite shops of user if authentication success" do
        get 'api/v1/favorite_shops', {:auth_token => @user.authentication_token}
        response.status.should == 200
        data = JSON.parse response.body
        data.should have_key 'shops'
        data['shops'].should be_instance_of(Array)
        data['shops'].first['shop']['id'].should == @shop.id
      end
    end

    describe "GET /api/v1/favorite_shops/:shop_id" do
      it "returns status 200 with {favorite: true} if shop in favorite list" do
        @favorite_shop = FactoryGirl.build(:favorite_shop) do |fs|
          fs.user = @user
          fs.shop = @shop
        end
        @favorite_shop.save
        get "api/v1/favorite_shops/#{@shop.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
        response.body.should == {:favorite => true}.to_json
      end
      it "returns status 200 with {favorite: false} if shop not in favorite list" do
        get "api/v1/favorite_shops/#{@shop.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
        response.body.should == {:favorite => false}.to_json
      end
    end

    describe "POST /api/v1/favorite_shops/:shop_id" do
      it "returns status 201 if shop successfully added into favorite list" do
        post "api/v1/favorite_shops/#{@shop.id}", {:auth_token => @user.authentication_token}
        response.status.should == 201
      end
      it "returns status 401 if authentication fail" do
        post "api/v1/favorite_shops/#{@shop.id}", {:auth_token => ''}
        response.status.should == 401
      end
    end

    describe "DELETE /api/v1/favorite_shops/:shop_id" do
      before(:each) do
        @favorite_shop = FactoryGirl.build(:favorite_shop) do |fs|
          fs.user = @user
          fs.shop = @shop
        end
        @favorite_shop.save
      end
      it "returns status 200 if shop successfully removed from favorite list" do
        delete "api/v1/favorite_shops/#{@shop.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
      end
      it "returns status 401 if authentication fail" do
        delete "api/v1/favorite_shops/#{@shop.id}", {:auth_token => ''}
        response.status.should == 401
      end
    end
  end

  context "wish list" do
    describe "GET /api/v1/wish_lists" do
      before(:each) do
        @wish_list = FactoryGirl.build(:wish_list) do |fs|
          fs.user = @user
          fs.shop_product = @shop_product
        end
        @wish_list.save
      end
      it "returns status 200 with all wish products of user if authentication success" do
        get 'api/v1/wish_lists', {:auth_token => @user.authentication_token}
        response.status.should == 200
        data = JSON.parse response.body
        data.should have_key 'shop_products'
        data['shop_products'].should be_instance_of(Array)
        data['shop_products'].first['shop_product']['id'].should == @shop_product.id
      end
    end

    describe "GET /api/v1/wishlist/:shop_product_id" do
      it "returns status 200 with {favorite: true} if product in wish list" do
        @wish_list = FactoryGirl.build(:wish_list) do |fs|
          fs.user = @user
          fs.shop_product = @shop_product
        end
        @wish_list.save
        get "api/v1/wish_lists/#{@shop_product.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
        response.body.should == {:favorite => true}.to_json
      end
      it "returns status 200 with {favorite: false} if product not in wish list" do
        get "api/v1/wish_lists/#{@shop_product.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
        response.body.should == {:favorite => false}.to_json
      end
    end

    describe "POST /api/v1/wishlist/:shop_product_id" do
      it "returns status 201 if product successfully added into wish list" do
        post "api/v1/wish_lists/#{@shop_product.id}", {:auth_token => @user.authentication_token}
        response.status.should == 201
      end
      it "returns status 401 if authentication fail" do
        post "api/v1/wish_lists/#{@shop_product.id}", {:auth_token => ''}
        response.status.should == 401
      end
    end

    describe "DELETE /api/v1/wishlist/:shop_product_id" do
      before(:each) do
        @wish_list = FactoryGirl.build(:wish_list) do |fs|
          fs.user = @user
          fs.shop_product = @shop_product
        end
        @wish_list.save
      end
      it "returns status 200 if product successfully removed from wish list" do
        delete "api/v1/wish_lists/#{@shop_product.id}", {:auth_token => @user.authentication_token}
        response.status.should == 200
      end
      it "returns status 401 if authentication fail" do
        delete "api/v1/wish_lists/#{@shop_product.id}", {:auth_token => ''}
        response.status.should == 401
      end
    end
  end
end