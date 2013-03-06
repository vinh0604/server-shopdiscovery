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

  def show
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])
    @product.tags = Tag.create_tags(params[:tags]) unless params[:tags].blank?
    if @product.save
      render :show
    else
      render :nothing => true, :status => 500
    end
  end

  def update
    @product = Product.find(params[:id])
    @product.assign_attributes(params[:product])
    @product.tags = Tag.create_tags(params[:tags]) unless params[:tags].blank?
    if @product.save
      render :show
    else
      render :nothing => true, :status => 500
    end
  end

  def categories
    categories_tree = Category.categories_tree
    render :json => categories_tree
  end
end
