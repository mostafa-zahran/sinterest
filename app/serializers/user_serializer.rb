class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :user_token
end
