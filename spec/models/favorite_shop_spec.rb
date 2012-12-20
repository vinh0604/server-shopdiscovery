require 'spec_helper'

describe FavoriteShop do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @shop = FactoryGirl.create(:shop)
    @favorite_shop = FactoryGirl.build(:favorite_shop) do |w|
      w.user = @user
      w.shop = @shop
    end
    @favorite_shop.save
  end

  it "belongs to an user" do
    @favorite_shop.should respond_to(:user)
  end

  it "belongs to a shop" do
    @favorite_shop.should respond_to(:shop)
  end
end
