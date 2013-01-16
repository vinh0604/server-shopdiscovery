module API
  class Suggestions < Grape::API
    resource :suggestions do
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