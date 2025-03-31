class MovieSerializer
  def self.serialize(movies)
    {
      data: movies.map do |movie|
        {
          id: movie["id"],
          type: 'movie',
          attributes: {
            title: movie["title"],
            vote_average: movie["vote_average"]
          }
        }
      end
    }
  end

  def self.serialize_details(movie)
    {
      data:
        {
          id: movie.id,
          type: 'movie',
          attributes: {
            title: movie.title,
            release_year: movie.release_year,
            vote_average: movie.vote_average,
            runtime: movie.runtime,
            genres: movie.genres,
            summary: movie.summary,
            cast: movie.cast,
            review_count: movie.review_count,
            reviews: movie.reviews
          }
        }
    }
  end
end