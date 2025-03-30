class ViewingParty < ApplicationRecord
  has_many :viewing_parties_users
  has_many :users, through: :viewing_parties_users
end
