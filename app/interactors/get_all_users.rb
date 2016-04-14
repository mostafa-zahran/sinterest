class GetAllUsers
  include Interactor

  def call
    context.users = User.all
  end
end