module API
  class Reviews < Grape::API
    resource :reviews do
      desc "Create new review"
      params do
        requires :reviewable_type, :type => String, :desc => 'Reviewable object type'
        requires :reviewable_id, :type => Integer, :desc => 'Reviewable object id'
        requires :rating, :type => Integer, :desc => 'Review rating score'
      end
      post '/' do
        authenticate!
        class_name = params[:reviewable_type].classify
        reviewable = class_name.constantize.find(params[:reviewable_id])
        reviewer = current_user
        review = Review.where(:reviewer_id => reviewer.id, :reviewable_id => reviewable.id, :reviewable_type => class_name).first
        review ||= Review.new(:reviewer_id => reviewer.id, :reviewable_id => reviewable.id, :reviewable_type => class_name)
        review.title = params[:title]
        review.content = params[:content]
        review.rating = params[:rating]
        if review.save
          review
        else
          error!({message: 'Can not create review!'}.to_json, 500)
        end
      end

      desc "Get all reviews of a reviewable object"
      params do
        requires :reviewable_type, :type => String, :desc => 'Reviewable object type'
        optional :page, :type => Integer
        optional :offset, :type => Integer
      end
      get '/:reviewable_id' do
        clazz = params[:reviewable_type].classify.constantize
        reviewable_object = clazz.find(params[:reviewable_id])
        @reviews = reviewable_object.reviews.includes(:reviewer).
                   where{(title != nil) & (title != '')}.
                   order('reviews.updated_at DESC')
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
      end
      get '/:reviewable_id/summary' do
        clazz = params[:reviewable_type].classify.constantize
        reviewable_object = clazz.find(params[:reviewable_id])
        result = {
          :star_count => {},
          :user_rating => 0,
          :rating => reviewable_object.avg_score,
          :rating_count => reviewable_object.review_count
        }
        for i in 1..5
          result[:star_count][i] = reviewable_object.reviews.where(:rating => i).count
        end
        if current_user
          user_rating = reviewable_object.reviews.where(:reviewer_id => current_user.id).first
          result[:user_rating] = user_rating.rating if user_rating
        end
        result
      end
    end
  end
end
