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

  it "has many wish lists" do
    @shop_product.should respond_to :wish_lists
  end

  context "search products" do
    before(:each) do
      @category = FactoryGirl.create(:sub_category)
      @shop = FactoryGirl.create(:shop)
      @product = FactoryGirl.build(:product) do |p|
        p.category = @category
      end
      @product.save
      @shop_product = FactoryGirl.build(:shop_product) do |sp|
        sp.product = @product
        sp.shop = @shop
      end
      @shop_product.save
    end
    it "search for keyword" do
      params = {:keyword => @product.name.downcase}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
    it "search for barcode when params[:keyword] start with EAN:" do
      params = {:keyword => "EAN:#{@product.barcode}"}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
    it "filter with category when params[:category] provided" do
      params = {:keyword => @product.name.downcase, :category => @category.id}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
    it "filter with shop within distance when params[:distance] and params[:location] provided" do
      params = {:keyword => @product.name.downcase,
                :location => @shop.location.to_s,
                :distance => 1}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
    it "filter with condition when params[:condition] provided" do
      params = {:keyword => @product.name.downcase,
                :condition => @shop_product.status}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
    it "filter with price when params[:min_price] or params[:max_price] provided" do
      params = {:keyword => @product.name.downcase,
                :min_price => @shop_product.price - 1,
                :max_price => @shop_product.price + 1}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
    it "filter with avg_score when params[:min_score] provided" do
      params = {:keyword => @product.name.downcase,
                :min_score => @shop_product.avg_score}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
    it "sort according to distance from location when params[:sort] = SORT_TYPE[:distance]" do
      params = {:keyword => @product.name.downcase, 
                :location => @shop.location.to_s,
                :sort => ShopProduct::SORT_TYPE[:distance]}
      shop_products = ShopProduct.search_products(params)
      shop_products.length.should == 1
      shop_products.first.id.should == @shop_product.id
    end
  end
end
