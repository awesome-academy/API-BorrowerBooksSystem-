class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  def login
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      hash_response = {
        user: user.name,
        token: token
      }
      handle_resonse(hash_response, :ok)
    else
      handle_resonse({message: I18n.t("authenticate.invalid")}, :unauthorized)
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
