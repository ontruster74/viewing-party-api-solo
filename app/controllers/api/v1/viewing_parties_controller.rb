class ViewingPartiesController < ApplicationController
  def create
    movie = Movie.find(params[:movie_id])
    user_ids = params[:user_ids]

    viewing_party = ViewingParty.new(
      name: params[:name],
      start_time: params[:start_time],
      end_time: params[:end_time],
      movie_id: movie.id,
    )

    user_ids.each do |user_id|
      viewing_party.users << User.find(user_id)
    end

    render json: viewing_party, status: :created
  end
end