module EnsureReturnAllUsers
  def ensure_return_all_users
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    user_names = body['users'].map { |user| user['name'] }
    expect(user_names).to match_array(['Mostafa Kamel', 'Mona Ali'])
    user_emails = body['users'].map { |user| user['email'] }
    expect(user_emails).to match_array(%w(mostafa.k.zahran@gmail.com mona.ali@gmail.com))
    user_token = body['users'].map { |user| user['user_token'] }
    expect(user_token).not_to be_empty
  end
end