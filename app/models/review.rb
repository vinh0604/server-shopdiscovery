class Review < ActiveRecord::Base
  belongs_to :reviewer, :class_name => 'User'
  belongs_to :reviewable, :polymorphic => true
  after_save :calculate_statistic

  private
  def calculate_statistic
    reviewable_object = self.reviewable
    reviewable_object.avg_score = reviewable_object.reviews.average('rating')
    reviewable_object.review_count = reviewable_object.reviews.count
    reviewable_object.save
  end
end
