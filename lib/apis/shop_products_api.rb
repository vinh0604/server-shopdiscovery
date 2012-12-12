module API
  class ShopProducts < Grape::API
    resource :shop_products do
      desc "Get shop products"
      params do
        optional :page, :type => Integer
        optional :offset, :type => Integer
      end
      get '/' do
        query = ShopProduct.includes(:thumb, :product, :shop).order(:id)
        if params[:product_id]
          query = query.where(:product_id => params[:product_id])
        elsif params[:shop_id]
          query = query.where(:shop_id => params[:shop_id])
          query = query.where('products.category_id = ?', params[:category_id]) unless params[:category_id].nil?
        end
        if params[:page] and params[:per_page]
          @shop_products = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          @shop_products = query.page(params[:page])
        else
          @shop_products = query.page(1)
        end
        present @shop_products, :with => API::RablPresenter, :source => 'api/shop_products'
      end

      desc "Get shop product detail"
      get '/:id' do
        @shop_product = ShopProduct.find(params[:id])
        present @shop_product, :with => API::RablPresenter, :source => 'api/shop_product'
      end
    end
  end
end
