module API
  class Products < Grape::API
    resource :products do
      desc "Get all products"
      params do
        optional :category_id, :type => Integer, :desc => "Products' category id"
        optional :page, :type => Integer
        optional :per_page, :type => Integer
      end
      get '/' do
        query = Product.includes(:category)
        query = query.where('products.category_id = ?', params[:category_id]) if params[:category_id]
        if params[:page] and params[:per_page]
          products = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          products = query.page(params[:page])
        else
          products = query.page(1)
        end

        present products, :with => API::RablPresenter, :source => 'api/products'
      end
    end

    resource :categories do
      desc "Get all categories"
      params do
        optional :parent_id, :type => String, :desc => "Categories' parent id"
      end
      get '/' do
        if params[:parent_id]
          categories = Category.where(:parent_id => params[:parent_id]).all
        else
          categories = Category.where{(parent_id == nil) | (parent_id == '')}.all
        end
        categories.to_json(:methods => :has_children?)
      end
    end
  end
end
