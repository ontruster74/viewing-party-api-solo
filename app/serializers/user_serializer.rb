class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  def self.format_user_list(users)
    { data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              username: user.username
            }
          }
        end
    }
  end

  def self.format_user_profile(user)
    { data:
      {
        id: user.id.to_s,
        type: "user",
        attributes: {
          name: user.name,
          username: user.username,
          viewing_parties_hosted: ViewingPartySerializer.serialize_for_profile(user.hosted_parties), 
          viewing_parties_attended: ViewingPartySerializer.serialize_for_profile(user.parties_attended)
        }
      }
    }
  end
end