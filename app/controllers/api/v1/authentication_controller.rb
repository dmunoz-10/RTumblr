class Api::V1::AuthenticationController < ApiController
  skip_before_action :authenticate_request

  # Takes the JSON parameters for email and password through the params hash
  # and pass them to the AuthenticateUser command. If it succeeds, it will send
  # the JWT back to the user.
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])
    if command.success?
      render json: { auth_token: command.result }, status: :ok
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
