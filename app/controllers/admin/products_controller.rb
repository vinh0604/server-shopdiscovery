class Admin::ProductsController < Admin::BaseController
  respond_to :json
  def index
    query = Product.includes(:category).order(:id)
    query = query.where(:category_id => params[:category_id]) unless params[:category_id].blank?
    query = query.where("products.textsearchable@@plainto_tsquery('product',?) = 't'", params[:keyword]) unless params[:keyword].blank?
    if params[:page] and params[:per_page]
      @products = query.page(params[:page]).per(params[:per_page])
    elsif params[:page]
      @products = query.page(params[:page])
    else
      @products = query.page(1)
    end
  end

  def categories
    categories_tree = Category.categories_tree
    render :json => categories_tree
  end
end
