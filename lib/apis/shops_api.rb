module API
  class Shops < Grape::API
    resource :shops do
      desc "Get all shops"
      params do
        optional :keyword, :type => String, :desc => 'Search keyword'
        optional :page, :type => Integer
        optional :offset, :type => Integer
      end
      get '/' do
        query = Shop.includes(:tags).order('shops.id')
        query = query.where('lower(name) LIKE :keyword OR lower(tags.value) LIKE :keyword', :keyword => "%#{params[:keyword]}%") unless params[:keyword].blank?
        if params[:page] and params[:per_page]
          query = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          query = query.page(params[:page])
        else
          query = query.page(1)
        end

        present query, :with => API::RablPresenter, :source => 'api/shops'
      end

      desc "Get shop with id"
      get '/:id' do
        @shop = Shop.find(params[:id])
        present @shop, :with => API::RablPresenter, :source => 'api/shop'
      end

      desc "Get shop's categories"
      get '/:id/categories' do
        # categories' sequence of all products in shops
        sequences = Category.joins(:products => :shop_products).
          where('shop_products.shop_id = ?', params[:id]).
          map do |c| 
            seq = c.sequence.to_s.split(',')
            seq << c.id.to_s
            seq
          end

        if params[:parent_id]
          # sub categories' id of parent category
          sub_category_ids = Category.where(:parent_id => params[:parent_id]).
            map { |c| c.id.to_s }
          # convert categories' sequence to categories' id array
          shop_category_ids = sequences.flatten.uniq
          category_ids = sub_category_ids & shop_category_ids
        else
          # first-level categories' id
          category_ids = sequences.map { |s| s.first }.uniq
        end
        categories = Category.where(:id => category_ids).all
        categories.to_json(:methods => :has_children?)
      end
    end
  end
end
