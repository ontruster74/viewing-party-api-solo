class ViewingParty < ApplicationRecord
  has_many :viewing_parties_users
  has_many :users, through: :viewing_parties_users

  def add_invitee(invitee)
    self.invitees.push(invitee)
    self.invitees.uniq!
    save!
  end
end
