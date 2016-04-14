class ApplicationController < ActionController::API
  include ActionController::Serialization,
          ActionController::HttpAuthentication::Token::ControllerMethods,
          CanCan::ControllerAdditions

  before_action :authenticate

  rescue_from CanCan::AccessDenied do |exception|
    render json: exception.message, status: :unauthorized
  end

  def current_user
    @current_user
  end

  protected

  def authenticate
    authenticate_with_http_token do |token, options|
      @current_user = User.find_by_user_token(token)
    end
  end
end
