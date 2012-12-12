module API
  class Reviews < Grape::API
    resource :reviews do
      desc "Get all reviews of a reviewable object"
      params do
        requires :reviewable_type, :type => String, :desc => 'Reviewable object type'
        optional :page, :type => Integer
        optional :offset, :type => Integer
      end
      get '/:reviewable_id' do
        clazz = params[:reviewable_type].classify.constantize
        reviewable_object = clazz.find(params[:reviewable_id])
        @reviews = reviewable_object.reviews.includes(:reviewer).order('reviews.updated_at DESC')
        if params[:page] and params[:per_page]
          @reviews = @reviews.page(params[:page]).per(params[:per_page])
        elsif params[:page]
          @reviews = @reviews.page(params[:page])
        else
          @reviews = @reviews.page(1)
        end

        present @reviews, :with => API::RablPresenter, :source => 'api/reviews'
      end

      desc "Get all reviews of a reviewable object"
      params do
        requires :reviewable_type, :type => String, :desc => 'Reviewable object type'
        optional :page, :type => Integer
        optional :offset, :type => Integer
      end
      get '/:reviewable_id/summary' do
        clazz = params[:reviewable_type].classify.constantize
        reviewable_object = clazz.find(params[:reviewable_id])
        summary = {}
        for i in 1..5
          summary[i] = reviewable_object.reviews.where(:rating => i).count
        end
        summary
      end
    end
  end
end
