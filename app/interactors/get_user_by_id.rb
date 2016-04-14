class GetUserById
  include Interactor

  before do
    context.fail! if context.id.blank? || (@user = User.find_by_id(context.id)).blank?
  end

  def call
    context.user = @user
  end
end