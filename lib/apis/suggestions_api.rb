module API
  class Suggestions < Grape::API
    resource :suggestions do
      desc 'Get all most frequent search term start with params[:keyword]'
      params do
        requires :keyword, :type => String
      end
      get '/' do
        @search_terms = SearchCompletion.where(["search_term ILIKE ?", "#{params[:keyword]}%"]).
                                          order('search_count DESC').limit(10).map(&:search_term)
        @search_terms
      end

      desc 'Get products which name contain params[:keyword]'
      params do
        requires :keyword, :type => String
      end
      get '/products' do
        @products = Product.where('name ILIKE ?', "%#{params[:keyword]}%").limit(10).all
        @products.to_json(:only  => [:id,:name])
      end
    end
  end
end