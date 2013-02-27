module API
  class Search < Grape::API
    resource :search do
      desc "Search shop products"
      params do
        optional :keyword, :type => String, :desc => 'Search keyword'
        optional :condition, :type => Integer, :desc => 'Condition of search result'
        optional :category, :type => Integer, :desc => 'Category of search result'
        optional :distance, :type => Float, :desc => 'Distance from user\'s location'
        optional :location, :type => String, :desc => "User's location in WKT format"
        optional :min_price, :type => Float, :desc => 'Minimum price'
        optional :max_price, :type => Float, :desc => 'Maximum price'
        optional :min_score, :type => Float, :desc => 'Minimum average review score'
        optional :sort, :type => Integer, :desc => 'Search result sort type'
        optional :page, :type => Integer
        optional :per_page, :type => Integer
      end
      get '/' do
        shop_products = ShopProduct.search_products(params)
        if shop_products.total_count > 0 and shop_products.offset_value == 0
          search_term = params[:keyword].blank? ? '' : params[:keyword].strip.gsub('-',' ').downcase
          SearchCompletion.add_term(search_term)
        end
        present shop_products, :with => API::RablPresenter, :source => 'api/search_results'
      end
    end
  end
end