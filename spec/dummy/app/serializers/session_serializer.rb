class SessionSerializer < UserBaseSerializer
  attributes :email, :user_id, :access_token

  def user_id
    object.try(:id)
  end

  def token_type
    'Bearer'
  end

end
