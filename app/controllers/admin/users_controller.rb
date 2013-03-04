class Admin::UsersController < Admin::BaseController
  respond_to :json
  protect_from_forgery :only => [:create]
  def index
    query = User.includes(:contact).order(:id)
    query = query.joins(:contact).
                  where("username ILIKE :keyword OR email ILIKE :keyword OR (first_name || ' ' || last_name) ILIKE :keyword", 
                    keyword: "%#{params[:keyword]}%") unless params[:keyword].blank?
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

  def create
    @contact = Contact.create(params[:contact])
    @user = User.new(params[:user])
    @user.avatar = File.open(params[:user][:avatar_cache]) unless params[:user][:avatar_cache].blank?
    @user.contact = @contact
    if @user.save
      render :show
    else
      render :nothing => true, :status => 500
    end
  end

  def update
    @user = User.find(params[:id])
    @user.contact.update_attributes(params[:contact]) if @user.contact
    @user.avatar = File.open(params[:user][:avatar_cache]) unless params[:user][:avatar_cache].blank?
    if @user.update_attributes(params[:user])
      render :show
    else
      render :nothing => true, :status => 500
    end
  end

  def upload
    @avatar = AvatarUploader.new
    @avatar.cache!(params[:avatar])
    render :text => @avatar.current_path
  end
end
