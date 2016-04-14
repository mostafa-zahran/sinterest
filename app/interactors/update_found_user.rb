class UpdateFoundUser
  include Interactor

  before do
    context.fail! if context.user.blank? || context.user_params.blank?
  end

  def call
    unless context.user.update(context.user_params)
      context.fail!
    end
  end
end