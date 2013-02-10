module API
  class Notifications < Grape::API
    resource :notifications do
      desc "Get all notifications of current user"
      params do
        optional :page, :type => Integer
        optional :per_page, :type => Integer
      end
      get '/' do
        authenticate!
        query = current_user.notifications.order('created_at DESC')
        if params[:page] and params[:per_page]
          query = query.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          query = query.page(params[:page])
        else
          query = query.page(1)
        end
        present query, :with => API::RablPresenter, :source => 'api/notifications'
      end

      desc "Get number of unread notifications"
      get '/check' do
        authenticate!
        notification_count = current_user.notifications.where(:status => Notification::STATUSES[:new]).count
        {:count => notification_count}
      end

      desc "Mark notifications statuses read"
      params do
        requires :ids, :type => String, :desc => 'Read notifications ids in JSON'
      end
      put '/read' do
        authenticate!
        ids = JSON.parse params[:ids]
        Notification.where(:id => ids, :user_id => current_user.id).update_all("status = #{Notification::STATUSES[:read]}")
        {:success => true}
      end
    end
  end
end