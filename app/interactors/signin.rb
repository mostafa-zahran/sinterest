class Signin
  include Interactor

  before do
    context.fail! if context.current_user.present? || context.session_params.blank? || (@user = User.find_by_email(context.session_params[:email])).blank? || (@user.authenticate(context.session_params[:password]).blank?)
  end

  def call
    context.user = @user
  end
end