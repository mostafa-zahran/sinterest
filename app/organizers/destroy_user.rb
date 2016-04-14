class DestroyUser
  include Interactor::Organizer

  organize GetUserById, DestroyFoundUser
end