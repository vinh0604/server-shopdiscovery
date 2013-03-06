class Admin::ShopsController < Admin::BaseController
  respond_to :json
  def index
    query = Shop.order(:id)
    query = query.where("name ILIKE ?", "%#{params[:keyword]}%") unless params[:keyword].blank?
    if params[:page] and params[:per_page]
      @shops = query.page(params[:page]).per(params[:per_page])
    elsif params[:page]
      @shops = query.page(params[:page])
    else
      @shops = query.page(1)
    end
  end

  def show
    @shop = Shop.includes(:managers => :user).find(params[:id])
  end

  def create
    @shop = Shop.new(params[:shop])
    if @shop.save
      Manager.update_shop_managers(@shop,params[:managers]) unless params[:managers].blank?
      render :show
    else
      render :nothing => true, :status => 500
    end
  end

  def update
    @shop = Shop.find(params[:id])
    @shop.update_attributes(params[:shop])
    if @shop.save
      Manager.update_shop_managers(@shop,params[:managers]) unless params[:managers].blank?
      render :show
    else
      render :nothing => true, :status => 500
    end
  end
end
