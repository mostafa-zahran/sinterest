class Signout
  include Interactor

  before do
    context.fail! if context.user.blank?
  end

  def call
    context.user.generate_user_token
    context.user.save(validate: false)
  end
end