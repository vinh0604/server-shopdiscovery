module API
  class Sessions < Grape::API
    resource :sessions do
      desc "Login"
      params do
        requires :email, :type => String, :desc => "Username or email"
        requires :password, :type => String, :desc => "Password"
      end
      post '/' do
        user = User.find_for_database_authentication(:login => params[:login])
        if user and user.valid_password?(params[:password])
          user
        else
          error!('403 AuthenticationFailed', 403)
        end
      end

      desc "Log out"
      delete '/' do
        authenticate!
        current_user.reset_authentication_token!
      end
    end
  end
end
