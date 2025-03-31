class Movie 
  attr_reader :id, :title, :release_year, :vote_average, :runtime, :genres, :summary, :cast, :review_count, :reviews

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @release_year = data[:release_date].split('-').first
    @vote_average = data[:vote_average]
    @runtime = calc_runtime(data[:runtime])
    @genres = data[:genres].map{ |genre| genre[:name] }
    @summary = data[:overview]
    @cast = data[:credits][:cast].first(10).map{ |cast| {character: cast[:character], actor: cast[:name]}}
    @review_count = data[:reviews][:total_results]
    @reviews = data[:reviews][:results].first(5).map { |review| {author: review[:author], review: review[:content]} }
  end

  def calc_runtime(runtime)
    hours = runtime / 60
    minutes = runtime % 60
    return hours_minutes = "#{hours} hours #{minutes} minutes"
  end
end