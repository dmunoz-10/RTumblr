class ApiController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    # Returns the current user becoming available to all
    # controllers inheriting from ApplicationController
    @current_user = AuthorizeApiRequest.call(request.headers).result
    # Render an error in a json if the result of the above code is false
    render json: { error: 'Not authorized' }, status: 401 unless @current_user
  end
end
