class CreateUser
  include Interactor

  before do
    context.fail! if context.user_params.blank?
  end

  def call
    user = User.new(context.user_params)
    if user.save
      context.user = user
    else
      context.user = user
      context.fail!
    end
  end
end