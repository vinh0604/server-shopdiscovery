class Admin::UsersController < Admin::BaseController
  respond_to :json
  def index
    query = User.includes(:contact).order(:id)
    if params[:page] and params[:per_page]
      @users = query.page(params[:page]).per(params[:per_page])
    elsif params[:page]
      @users = query.page(params[:page])
    else
      @users = query.page(1)
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
