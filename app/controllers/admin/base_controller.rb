class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!, :require_admin_user

  private
  def require_admin_user
    redirect_to '/login', :alert => 'Please login first.' unless current_user.admin
  end
end