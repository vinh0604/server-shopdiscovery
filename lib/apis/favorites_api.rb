module API
  class Favorites < Grape::API
    resource :favorite_shops do
      desc "Get all favorite shops of user"
      get '/' do
        if current_user
          favorite_shops = Shop.joins(:favorite_shops).where("favorite_shops.user_id = ?",current_user.id).page(1).per(nil)
          present favorite_shops, :with => API::RablPresenter, :source => 'api/shops'
        else
          {:shops => []}
        end
      end

      desc "Check if the shop is in favorite list"
      get '/:shop_id' do
        if current_user and current_user.favorite_shops.where(:shop_id => params[:shop_id]).exists?
          {:favorite => true}
        else
          {:favorite => false}
        end
      end

      desc "Add the shop into favorite list"
      post '/:shop_id' do
        authenticate!
        if !current_user.favorite_shops.where(:shop_id => params[:shop_id]).exists?
          favorite_shop = current_user.favorite_shops.build(:shop_id => params[:shop_id])
          if favorite_shop.save
            {:success => true}
          else
            {:success => false}
          end
        else
          {:success => true}
        end
      end

      desc "Remove the shop from favorite list"
      delete '/:shop_id' do
        authenticate!
        favorite_shop = current_user.favorite_shops.where(:shop_id => params[:shop_id]).first
        if favorite_shop
          current_user.favorite_shops.delete(favorite_shop)
        end
        {:success => true}
      end
    end

    resource :wish_lists do
      desc "Get all products in user's wish list"
      get '/' do
        if current_user
          shop_products = ShopProduct.includes(:thumb, :product, :shop).joins(:wish_lists).where("wish_lists.user_id = ?",current_user.id).page(1).per(nil)
          present shop_products, :with => API::RablPresenter, :source => 'api/shop_products'
        else
          {:shop_products => []}
        end
      end

      desc "Check if the product is in wish list"
      get '/:shop_product_id' do
        if current_user and current_user.wish_lists.where(:shop_product_id => params[:shop_product_id]).exists?
          {:favorite => true}
        else
          {:favorite => false}
        end
      end

      desc "Add the product into wish list"
      post '/:shop_product_id' do
        authenticate!
        if !current_user.wish_lists.where(:shop_product_id => params[:shop_product_id]).exists?
          wish_list = current_user.wish_lists.build(:shop_product_id => params[:shop_product_id])
          if wish_list.save
            {:success => true}
          else
            {:success => false}
          end
        else
          {:success => true}
        end
      end

      desc "Remove the product from wish list"
      delete '/:shop_product_id' do
        authenticate!
        wish_list = current_user.wish_lists.where(:shop_product_id => params[:shop_product_id]).first
        if wish_list
          current_user.wish_lists.delete(wish_list)
        end
        {:success => true}
      end
    end
  end
end