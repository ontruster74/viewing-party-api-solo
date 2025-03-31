require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "GET /api/v1/movies/top_rated" do
    let(:stub_request) do
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{Rails.application.credentials.tmdb[:key]}").to_return(status:200, body: {
        results: Array.new(20) do |i|
          { id: i + 1, title: "Movie #{i + 1}", vote_average: (8.0 + i * 0.1)}
        end
      }.to_json)
    end
  
    it "returns first 20 top rated movies" do
      stub_request
      get "/api/v1/movies"

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response["movies"].size).to eq(20)
      expect(json_response["movies"].first["title"]).to eq("Movie 1")
    end
  end

  describe "GET /api/v1/movies/search" do
    let(:stub_request) do
      stub_request(:get, "https://api.themoviedb.org/3//search/movie?api_key=#{Rails.application.credentials.tmdb[:key]}")
      .with(
        query: { query: "Inception" }
      )
      .to_return(status:200, body: {
        results: [
          { id: 1, title: "Inception", vote_average: 8.8, release_date: "2010-07-16"},
          { id: 1, title: "Inception: The Cobol Job", vote_average: 7.5, release_date: "2010-07-13"}
        ]
      }.to_json)
    end
  
    it "returns first 20 movies based on a search query" do
      stub_request
      get "/api/v1/movies/search", params: { query: "Inception" }

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response["data"].size).to eq(2)
      expect(json_response["data"].first["title"]).to eq("Inception")
      expect(json_response["data"].last["title"]).to eq("Inception: The Cobol Job")
    end
  end

  describe "GET /api/v1/movies/search" do
    let(:movie_id) { 550 }
    let(:tmdb_url) {"https://api.themoviedb.org/3/movie/#{:movie_id}"}

    let(:movie_response) do
      {
        id: movie_id,
        title: "Fight Club",
        release_date: "1999-10-15",
        vote_average: 8.8,
        runtime: 139,
        genres: [{ id: 18, name: "Drama" }],
        summary: "If you don't know this movie, I can't help you.",
        credits: {
          cast: [
            { name: "Edward Norton", character: "The Narrator" },
            { name: "Brad Pitt", character: "Tyler Durden" }
          ]
        },
        reviews: {
          results: [
            { author: "John Doe", content: "Amazing movie!" },
            { author: "Jane Smith", content: "A masterpiece." }
          ]
        }
      }.to_json
    end

    let(:stub_request) do
      stub_request(:get, tmdb_url)
      .with(query: { api_key: Rails.application.credentials.tmdb[:key], append_to_response: "credits,reviews" })
      .to_return(status:200, body: movie_response)
    end
  
    it "returns first 20 movies based on a search query" do
      stub_request
      get "/api/v1/movies/search", params: { query: "Inception" }

      expect(response).to be_successful
      json_response = JSON.parse(response.body)

      expect(json_response["id"]).to eq(movie_id)
      expect(json_response["title"]).to eq("Fight Club")
      expect(json_response["release_date"]).to eq("1999-10-15")
      expect(json_response["vote_average"]).to eq(8.8)
      expect(json_response["runtime"]).to eq(139)
      expect(json_response["genres"].first["name"]).to eq("Drama")
      expect(json_response["summary"]).to eq("If you don't know this movie, I can't help you.")

      expect(json_response["cast"].size).to eq(2)
      expect(json_response["cast"].first["name"]).to eq("Edward Norton")
      expect(json_response["cast"].first["character"]).to eq("The Narrator")

      expect(json_response["reviews"]).to eq(2)
      expect(json_response["reviews"].first["author"]).to eq("John Doe")
      expect(json_response["reviews"].first["content"]).to eq("Amazing movie!")
    end
  end
end

