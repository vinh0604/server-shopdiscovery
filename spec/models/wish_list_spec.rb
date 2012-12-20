require 'spec_helper'

describe WishList do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @shop_product = FactoryGirl.create(:shop_product)
    @wish_list = FactoryGirl.build(:wish_list) do |w|
      w.user = @user
      w.shop_product = @shop_product
    end
    @wish_list.save
  end

  it "belongs to an user" do
    @wish_list.should respond_to(:user)
  end

  it "belongs to a shop product" do
    @wish_list.should respond_to(:shop_product)
  end
end
