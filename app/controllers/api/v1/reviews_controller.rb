class Api::V1::ReviewsController < ApplicationController

  def index
    reviews = Review.all
    render json: reviews
  end

  def create

    review = Review.create(description: params["description"], track_id: params["track_id"], user_id: current_user.id)
    if review
      render json: {review: ReviewSerializer.new(review)}, status: :created
    else
      render json: {error: 'failed to create review'}, status: :not_acceptable
    end
  end

end
