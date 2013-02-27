module API
  class Orders < Grape::API
    resource :orders do
      desc 'get orders in shop'
      params do
        requires :shop_id, :type => Integer
        requires :status, :type => Integer, :desc => 'Order status'
      end
      get '/' do
        authenticate!
        if current_user.managers.where(:shop_id => params[:shop_id]).exists?
          @orders = Order.includes(:shop_product, :user).joins(:shop_product => :shop).
                         where(:shops => {:id => params[:shop_id]}).
                         where(:status => params[:status])
          present @orders, :with => API::RablPresenter, :source => 'api/orders'
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end

      desc 'check number of order in shop'
      params do
        requires :shop_id, :type => Integer
        requires :status, :type => Integer, :desc => 'Order status'
      end
      get '/check' do
        authenticate!
        if current_user.managers.where(:shop_id => params[:shop_id]).exists?
          @count = Order.joins(:shop_product => :shop).
                         where(:shops => {:id => params[:shop_id]}).
                         where(:status => params[:status]).count
          {count: @count}
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end

      desc 'create new order'
      params do
        requires :shop_product_id, :type => Integer
        requires :amount, :type => Integer
        optional :contact, :type => String, :desc => 'Shipment Contact in JSON'
      end
      post '/' do
        authenticate!
        shop_product = ShopProduct.find(params[:shop_product_id])
        contact = params[:contact] ? JSON.parse(params[:contact]) : {}
        order = shop_product.place_order({amount: params[:amount], user_id: current_user.id, contact: contact})
        if order
          {success: true}
        else
          error!({message: 'Can not create order'}.to_json, 500)
        end
      end
    end
  end
end