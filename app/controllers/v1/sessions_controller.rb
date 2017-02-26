module V1
  class SessionsController < ApplicationController
    def create
      result = Signin.call(session_params: session_params, current_user: current_user)
      if result.success?
        render json: {user: UserSerializer.new(result.user, scope: {include_token: true})}, status: :ok
      else
        render json: nil, status: :unprocessable_entity
      end
    end

    def destroy
      result = Signout.call(user: current_user)
      render status: result.success? ? :no_content : :unprocessable_entity
    end

    private

    def session_params
      params.permit(:email, :password)
    end
  end
end
