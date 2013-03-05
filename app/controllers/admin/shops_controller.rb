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
end
