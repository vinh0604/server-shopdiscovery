class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!, :require_admin_user

  private
  def require_admin_user
    unless current_user.admin
      sign_out(current_user)
      redirect_to '/login', :alert => 'Please login as admin.'
    end
  end
end