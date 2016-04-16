module V1
  class SessionsController < ApplicationController
    def create
      result = Signin.call(session_params: session_params, current_user: current_user)
      render json: result.success? ? result.user : [], status: result.success? ? :ok : :unprocessable_entity
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
