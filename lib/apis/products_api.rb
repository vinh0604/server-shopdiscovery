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

      desc 'Find product'
      get '/:product_id' do
        @product = Product.find(params[:product_id])
        present @product, :with => API::RablPresenter, :source => 'api/product_detail'
      end

      desc "Create new product"
      params do
        requires :name, :type => String
        optional :barcode, :type => String
        optional :category_id, :type => Integer
        optional :specifics, :type => String, :desc => 'Product specifics in JSON'
      end
      post '/' do
        authenticate!
        specifics = params[:specifics].blank? ? {} : JSON.parse(params[:specifics])
        product = Product.new({
          :name => params[:name],
          :barcode => params[:barcode],
          :category_id => params[:category_id],
          :specifics => specifics
        })
        if product.save
          product
        else
          error!(product.errors.to_json(:methods => :full_messages), 400)
        end
      end

      desc "Update product"
      params do
        optional :name, :type => String
        optional :barcode, :type => String
        optional :category_id, :type => Integer
        optional :specifics, :type => String, :desc => 'Product specifics in JSON'
      end
      put '/:id' do
        authenticate!
        specifics = params[:specifics].blank? ? {} : JSON.parse(params[:specifics])
        product = Product.find(params[:id])
        product.name = params[:name] unless params[:name].blank?
        product.barcode = params[:barcode] unless params[:barcode].blank?
        product.category_id = params[:category_id] unless params[:category_id].blank?
        product.specifics = specifics unless specifics.blank?
        if product.save
          product
        else
          error!(product.errors.to_json(:methods => :full_messages), 400)
        end
      end

      desc 'Find product with barcode'
      get '/barcode/:ean' do
        @product = Product.find_by_barcode(params[:ean])
        if @product
          @product.to_json(:only  => [:id,:name])
        else
          {}
        end
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

      desc "Get category with parent and children"
      params do
        optional :category_id, :type => Integer
      end
      get '/list' do
        if params[:category_id]
          category = Category.find(params[:category_id])
          present category, :with => API::RablPresenter, :source => 'api/category'
        else
          categories = Category.where(:parent_id => nil).all
          {:children => categories.as_json(:only => [:id, :name])}
        end
      end
    end
  end
end
