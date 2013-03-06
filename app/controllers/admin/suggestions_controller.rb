class Admin::SuggestionsController < Admin::BaseController
  respond_to :json
  def tags
    @tags = Tag.where('value ILIKE ?', "%#{params[:query].strip}%").limit(10).map(&:value)
    render :json => @tags.as_json
  end

  def users
    @users = User.where('username ILIKE ?', "#{params[:query]}%").includes(:contact).limit(10)
  end
end