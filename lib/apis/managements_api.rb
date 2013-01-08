module API
  class Managements < Grape::API
    resource :managements do
      resource :shops do
        desc "Get all shops where user is manager"
        get '/' do
          authenticate!
          @shops = Shop.select("shops.*, managers.owner as is_owner").
                    joins(:managers).where('managers.user_id = ?', current_user.id)

          present @shops, :with => API::RablPresenter, :source => 'api/managements/shops'
        end

        desc "Get a shop"
        get '/:shop_id' do
          authenticate!
          @shop = Shop.select("shops.*, managers.owner as is_owner").
                    joins(:managers).
                    where('managers.user_id = ? AND shops.id = ?', current_user.id, params[:shop_id]).
                    first

          present @shop, :with => API::RablPresenter, :source => 'api/managements/shop'
        end

        desc "Create new shop"
        params do
          requires :name, :type => String, :desc => "Shop's name"
          optional :street_address, :type => String, :desc => "Shop's street address"
          optional :district, :type => String, :desc => "District name"
          optional :city, :type => String, :desc => "City name"
          optional :location, :type => String, :desc => "Shop's location in WKT"
          optional :phones, :type => String, :desc => "Shop's phones in JSON"
          optional :website, :type => String, :desc => "Shop's website"
          optional :description, :type => String, :desc => "Shop's description"
          optional :added_photos, :type => String, :desc => "Added photo ids in JSON"
        end
        post '/' do
          authenticate!
          phones = params[:phones] ? JSON.parse(params[:phones]) : []
          photos = params[:added_photos] ? JSON.parse(params[:added_photos]) : []
          attrs = {
            :name => params[:name],
            :street_address => params[:street_address],
            :district => params[:district],
            :city => params[:city],
            :website => params[:website],
            :description => params[:description],
            :location => params[:location],
            :phones => phones
          }
          @shop = Shop.new(attrs)
          @shop.creator = current_user
          if @shop.save
            # assign current user as shop manager
            Manager.create({
              :shop_id => @shop.id,
              :user_id => current_user.id,
              :owner => true
            })
            # add photo for shop
            Photo.where(:id => photos, :imageable_id => nil).each do |p|
              p.imageable = @shop
              p.save
            end
            @shop
          else
            error!('Can not create shop', 500)
          end
        end

        desc "Update a shop"
        params do
          optional :name, :type => String, :desc => "Shop's name"
          optional :street_address, :type => String, :desc => "Shop's street address"
          optional :district, :type => String, :desc => "District name"
          optional :city, :type => String, :desc => "City name"
          optional :location, :type => String, :desc => "Shop's location in WKT"
          optional :phones, :type => String, :desc => "Shop's phones in JSON"
          optional :website, :type => String, :desc => "Shop's website"
          optional :description, :type => String, :desc => "Shop's description"
          optional :added_photos, :type => String, :desc => "Added photo ids in JSON"
          optional :deleted_photos, :type => String, :desc => "Deleted photo ids in JSON"
        end
        put '/:shop_id' do
          authenticate!
          @shop = Shop.joins(:managers).
                    where('shops.id = ? AND managers.user_id = ?', params[:shop_id], current_user.id).
                    readonly(false).
                    first
          if @shop
            phones = params[:phones] ? JSON.parse(params[:phones]) : []
            added_photos = params[:added_photos] ? JSON.parse(params[:added_photos]) : []
            deleted_photos = params[:deleted_photos] ? JSON.parse(params[:deleted_photos]) : []
            attrs = {
              :name => params[:name],
              :street_address => params[:street_address],
              :district => params[:district],
              :city => params[:city],
              :website => params[:website],
              :description => params[:description],
              :location => params[:location],
              :phones => phones
            }
            @shop.update_attributes(attrs)
            
            # assign added photos for shop
            Photo.where(:id => added_photos, :imageable_id => nil).each do |p|
              p.imageable = @shop
              p.save
            end
            # destroy deleted photos from shops
            if !deleted_photos.empty?
              Photo.destroy_all("id IN (#{deleted_photos.join(',')}) AND ((imageable = 'Shop' AND imageable_id = #{@shop.id}) OR imageable_id IS NULL)")
            end
            
            # return response
            @shop
          else
            raise ActiveRecord::RecordNotFound
          end
        end

        desc "Delete a shop"
        delete '/:shop_id' do
          authenticate!
          @shop = Shop.joins(:managers).
                    where('shops.id = ? AND managers.user_id = ?', params[:shop_id], current_user.id).
                    first
          if @shop
            @shop.destroy
            {:success => true}
          else
            raise ActiveRecord::RecordNotFound
          end
        end
      end

      resource :products do
        # not yet implement
      end
    end

    resource :photos do
      desc "Upload photo"
      params do
        requires :image
      end
      post '/' do
        authenticate!
        photo = Photo.new
        photo.image = params[:image]
        if photo.save
          photo
        else
          error!('Can not save photo', 500)
        end
      end
    end
  end
end