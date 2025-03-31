require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "myspace_creator", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end

  describe "GET /api/v1/users/:id" do
    let!(:user) { User.create(name: "Tom", username: "myspace_creator", password: "test123") }
    let!(:second_user) { User.create(name: "Oprah", username: "oprah", password: "abcqwerty") }
    let!(:third_user) { User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy") } 

    let!(:hosted_party) do
      ViewingParty.create(
        name: "Movie Night",
        start_time: Time.now + 1.day,
        end_time: Time.now + 1.day + 2.hours,
        movie_id: 550,
        movie_title: "Fight Club",
        host_id: user.id,
        invitees: [third_user.id]
      )
    end

    let!(:invited_party) do
      ViewingParty.create(
        name: "Action Marathon",
        start_time: Time.now + 2.days,
        end_time: Time.now + 2.days + 3.hours,
        movie_id: 500,
        movie_title: "Resovoir Dogs",
        host_id: second_user.id,
        invitees: [user.id, third_user.id]
      )
    end

    it "Get a user's profile based on id" do
      get "/api/v1/users/#{user.id}"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:id]).to eq(user.id)
      expect(json[:name]).to eq(user.name)

      expect(json[:hosted_parties].size).to eq(1)
      expect(json[:hosted_parties].first[:id]).to eq(hosted_party.id)

      expect(json[:invited_parties].size).to eq(1)
      expect(json[:invited_parties].first[:id]).to eq(invited_party.id)
    end
  end
end
