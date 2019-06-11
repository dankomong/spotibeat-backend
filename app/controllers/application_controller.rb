class ApplicationController < ActionController::API

  # before_action :authorized, except: [:logged_in?]

  def current_user
    # hard coding 4 for now
    User.find(1)
  end

  def get_token(token)

  end

  def logged_in?
    !!current_user
  end

  # def authorized
  #   render json: {error: "Access denied, not authorized"}, status: 401 unless logged_in?
  # end

end
