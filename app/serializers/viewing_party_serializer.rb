class ViewingPartySerializer
  def self.serialize(viewing_party)
    {
      data: 
        {
          id: viewing_party["id"],
          type: 'viewing_party',
          attributes: {
            name: viewing_party["name"],
            start_time: viewing_party["start_time"],
            end_time: viewing_party["end_time"],
            movie_id: viewing_party["movie_id"],
            movie_title: viewing_party["movie_title"],
            invitees: UserSerializer.format_user_list(viewing_party["invitees"].map {|invitee_id| User.find(invitee_id.to_s)})[:data]
          }
        }
    }
  end
end