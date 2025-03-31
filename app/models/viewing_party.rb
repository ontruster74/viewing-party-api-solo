class ViewingParty < ApplicationRecord
  belongs_to :host, class_name:"User", foreign_key:"host_id"
  has_many :viewing_parties_users
  has_many :users, through: :viewing_parties_users

  def add_invitee(invitee)
    self.invitees.push(invitee)
    self.invitees.uniq!
    save!
  end
end
