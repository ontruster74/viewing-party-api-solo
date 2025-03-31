require "rails_helper"

RSpec.describe "Viewing Parties API", type: :request do
  describe "POST /api/v1/viewing_parties" do
    let!(:host) { User.create(name: "Tom", username: "myspace_creator", password: "test123") }
    let!(:invitee) { User.create(name: "Oprah", username: "oprah", password: "abcqwerty") }

    let!(:party_attributes) do
      {
        name: "Movie Night",
        start_time: Time.now + 1.day,
        end_time: Time.now + 1.day + 2.hours,
        movie_id: 550,
        movie_title: "Fight Club",
        host_id: host.id,
        invitees: [invitee.id]
      }        
    end

    it "Creates a viewing party" do
      expect {
        post "/api/v1/viewing_parties", params: party_attributes
      }.to change(ViewingParty, :count).by(1)

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:name]).to eq("Movie Night")
      expect(json[:movie_id]).to eq(550)
      expect(json[:host_id]).to eq(host.id)
      expect(json[:invitees]).to include(invitee.id)
    end
  end

  describe "PATCH /api/v1/viewing_parties" do
    let!(:host) { User.create(name: "Tom", username: "myspace_creator", password: "test123") }
    let!(:first_invitee) { User.create(name: "Oprah", username: "oprah", password: "abcqwerty") }
    let!(:second_invitee) { User.create(name: "Beyonce", username: "sasha_fierce", password: "blueivy") } 

    let!(:viewing_party) do
      ViewingParty.create(
        name: "Movie Night",
        start_time: Time.now + 1.day,
        end_time: Time.now + 1.day + 2.hours,
        movie_id: 550,
        movie_title: "Fight Club",
        host_id: host.id,
        invitees: [first_invitee.id]
      )
    end

    it "Adds a user to an existing viewing party" do
      patch "/api/v1/viewing_parties/#{viewing_party.id}", params: {invitees_user_id: second_invitee.id}

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:invitees]).to include(second_invitee.id)
    end
  end
end
