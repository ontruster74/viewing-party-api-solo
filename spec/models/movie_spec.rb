require 'rails_helper'

RSpec.describe Movie, type: :poro do
  describe "#initialize" do
    let(:movie_data) do
      {
        id: 550,
        title: "Fight Club",
        release_date: "1999-10-15",
        vote_average: 8.8,
        runtime: 139,
        genres: [{ name: "Drama" }, { name: "Action" }],
        summary: "If you don't know this movie, I can't help you.",
        credits: {
          cast: [
            { name: "Edward Norton", character: "The Narrator" },
            { name: "Brad Pitt", character: "Tyler Durden" }
          ]
        },
        reviews: {
          total_results: 200,
          results: [
            { author: "John Doe", content: "Amazing movie!" },
            { author: "Jane Smith", content: "A masterpiece." }
          ]
        }
      }
    end
    
    let(:movie) { Movie.new(movie_data) }

    it "initialized with the correct data" do
      expect(movie.id).to eq(550)
      expect(movie.title).to eq("Fight Club")
      expect(movie.vote_average).to eq(8.8)
      expect(movie.runtime).to eq("2 hours 19 minutes")
    end

    it "maps and returns genres" do
      expect(movie.genres).to eq(["Drama", "Action"])
    end

    it "maps and returns cast members and characters" do
      expect(movie.cast).to eq([
        { actor: "Edward Norton", character: "The Narrator" },
        { actor: "Brad Pitt", character: "Tyler Durden" }
      ])
    end

    it "returns count of reviews" do
      expect(movie.review_count).to eq(200)
    end

    it "maps and returns reviews and authors" do
      expect(movie.reviews).to eq([
        { author: "John Doe", review: "Amazing movie!" },
        { author: "Jane Smith", review: "A masterpiece." }
      ])
    end
  end
end


