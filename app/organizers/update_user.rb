class UpdateUser
  include Interactor::Organizer

  organize GetUserById, UpdateFoundUser
end