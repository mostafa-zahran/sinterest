class DestroyFoundUser
  include Interactor

  before do
    context.fail! if context.user.blank?
  end

  def call
    unless context.user.destroy
      context.fail!
    end
  end
end