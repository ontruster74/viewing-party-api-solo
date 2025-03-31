require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe "aalidations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:movie_title) }
    it { should validate_presence_of(:host_id) }
  end

  describe "associations" do
    it { should belong_to(:host).class_name('User') }
    it { should have_many(:viewing_parties_users) }
    it { should have_many(:users).through(:viewing_parties_users) }
  end
end
