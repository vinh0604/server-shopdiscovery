module API
  class Promotions < Grape::API
    resource :promotions do
      desc "Get all active promotions"
      params do
        optional :category_id, :type => Integer
        optional :page, :type => Integer
        optional :per_page, :type => Integer
      end
      get '/' do
        category_ids = []
        if params[:category_id]
          category = Category.find_by_id(params[:category_id])
          category_ids = category ? category.all_children : []
        end
        query = ShopProduct.includes(:active_promotion, :product).where('promotions.active = ?', true)
        query = query.category(category_ids) unless category_ids.empty?
        if params[:page] and params[:per_page]
          query = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          query = query.page(params[:page])
        else
          query = query.page(1)
        end
        present query, :with => API::RablPresenter, :source => 'api/promotions'
      end

      desc "Create new promotion"
      params do
        requires :shop_product_id, :type => Integer
        requires :expires, :type => DateTime
        requires :price, :type => Float
        requires :active, :type => Boolean
        optional :amount, :type => Integer
      end
      post '/' do
        authenticate!
        shop_product = ShopProduct.find(params[:shop_product_id])
        if Manager.where(:shop_id => shop_product.shop_id, :user_id => current_user.id).exists?
          promotion = Promotion.new({
            :shop_product_id => params[:shop_product_id],
            :price => params[:price],
            :expires => params[:expires],
            :active => params[:active],
            :amount => params[:amount]
          })
          if promotion.save
            promotion
          else
            error!(promotion.errors.to_json(:methods => :full_messages), 500)
          end
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end

      desc "Update a promotion"
      params do
        requires :expires, :type => DateTime
        requires :price, :type => Float
        requires :active, :type => Boolean
        optional :amount, :type => Integer
      end
      put '/:id' do
        authenticate!
        promotion = Promotion.find(params[:id])
        shop_product = promotion.shop_product
        if shop_product and Manager.where(:shop_id => shop_product.shop_id, :user_id => current_user.id).exists?
          promotion.assign_attributes({
            :price => params[:price],
            :expires => params[:expires],
            :active => params[:active],
            :amount => params[:amount]
          })
          if promotion.save
            promotion
          else
            error!(promotion.errors.to_json(:methods => :full_messages), 500)
          end
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end

      desc "Delete a promotion"
      delete '/:id' do
        authenticate!
      end
    end
  end
end