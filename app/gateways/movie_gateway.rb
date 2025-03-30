class MovieGateway

  def self.conn 
    @conn ||= Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params["api_key"] = Rails.application.credentials.tmdb[:key]
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.top_rated
    response = conn.get("/3/movie/top_rated")
    parsed_response = JSON.parse(response.body)
    movies = parsed_response['results']&.first(20)
  end

  def self.movie_search(query)
    response = conn.get("/3/search/movie") do |req|
      req.params['query'] = query
    end
    parsed_response = JSON.parse(response.body)
    movies = parsed_response['results']&.first(20)
  end

  def self.movie_find(id)
    response = conn.get("/3/find/#{id}") 
    parsed_response = JSON.parse(response.body)
    movie = parsed_response['results']
  end
end