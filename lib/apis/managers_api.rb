module API
  class Managers < Grape::API
    resource :managers do
      desc "Get all managers of shop"
      params do
        requires :shop_id, :type => Integer
      end
      get '/' do
        shop = Shop.find(params[:shop_id])
        managers = shop.managers
        present managers, :with => API::RablPresenter, :source => 'api/managers'
      end

      desc "Add manager to shop"
      params do
        requires :shop_id, :type => Integer
        optional :user_id, :type => Integer
        optional :username, :type => String
      end
      post '/' do
        authenticate!
        # check if current user if shop owner
        if Manager.where(:shop_id => params[:shop_id], :owner => true, :user_id => current_user.id).exists?
          if params[:username]
            user = User.find_by_username(params[:username])
          else
            user = User.find_by_id(params[:user_id])
          end
          error!({message: 'User not found'}.to_json, 500) if user.nil?
          # create manager if not exists
          unless Manager.where(:shop_id => params[:shop_id], :user_id => user.id).exists?
            Manager.create(:shop_id => params[:shop_id], :user_id => user.id)
          end
          {:success => true}
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end

      desc "Remove manager from shop"
      params do
        requires :shop_id, :type => Integer
      end
      delete '/:id' do
        authenticate!
        # check if current user if shop owner
        if Manager.where(:shop_id => params[:shop_id], :owner => true, :user_id => current_user.id).exists?
          # delete manager if exists and not current user
          manager = Manager.where(:shop_id => params[:shop_id], :id => params[:id]).first
          if manager && (manager.id != current_user.id)
            manager.destroy
          end
          {:success => true}
        else
          error!({message: '401 Unauthorized'}.to_json, 401)
        end
      end
    end
  end
end