module V1
  class UsersController < ApplicationController
    load_and_authorize_resource

    def index
      result = GetAllUsers.call
      render json: {users: result.success? ? result.users.map{|user| UserSerializer.new(user)} : []}
    end

    def show
      result = GetUserById.call(id: params[:id])
      render json: {user: result.success? ? UserSerializer.new(result.user) : []}
    end

    def create
      result = CreateUser.call(user_params: user_params)
      if result.success?
        render json: {user: UserSerializer.new(result.user)}, status: :created, location: v1_user_url(result.user)
      else
        render json: result.user.errors, status: :unprocessable_entity
      end
    end

    def update
      result = UpdateUser.call(id: params[:id], user_params: user_params)
      if result.success?
        render json: {user: UserSerializer.new(result.user)}
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
      params.permit(:name, :email, :admin, :password, :password_confirmation)
    end
  end
end