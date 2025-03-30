class Api::V1::MoviesController < ApplicationController
  def index 
    if params[:query].present?
      movie_list = MovieGateway.movie_search(params[:query])
    else
      movie_list = MovieGateway.top_rated
    end
    render json: MovieSerializer.serialize(movie_list)
  end
end