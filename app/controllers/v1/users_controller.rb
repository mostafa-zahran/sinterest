module V1
  class UsersController < ApplicationController
    load_and_authorize_resource

    def index
      result = GetAllUsers.call
      render json: result.success? ? result.users : []
    end

    def show
      result = GetUserById.call(id: params[:id])
      render json: result.success? ? result.user : []
    end

    def create
      result = CreateUser.call(user_params: user_params)
      if result.success?
        render json: result.user, status: :created, location: v1_user_url(result.user)
      else
        render json: result.user.errors, status: :unprocessable_entity
      end
    end

    def update
      result = UpdateUser.call(id: params[:id], user_params: user_params)
      if result.success?
        render json: result.user
      else
        render json: result.user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      result = DestroyUser.call(id: params[:id])
      render status: result.success? ? :no_content : :unprocessable_entity
    end

    private

    def user_params
      params.permit(:name, :email, :admin)
    end
  end
end