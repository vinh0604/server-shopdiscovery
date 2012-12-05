require_relative 'sessions_api'
require_relative 'users_api'
module API
  class AppAPI < Grape::API
    version 'v1'
    format :json
    prefix "api"

    helpers do
      def current_user
        @current_user ||= User.find_for_authentication(:authentication_token => params[:auth_token])
      end

      def authenticate!
        error!({message: '401 Unauthorized'}.to_json, 401) unless current_user
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rack::Response.new([ e.message ], 500, { "Content-type" => "text/error" }).finish
    end

    mount API::Sessions
    mount API::Users
  end
end
