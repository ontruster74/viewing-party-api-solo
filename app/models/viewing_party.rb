class ViewingParty < ApplicationRecord
  belongs_to :host, class_name:"User", foreign_key:"host_id"
  has_many :viewing_parties_users
  has_many :users, through: :viewing_parties_users

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true
  validates :host_id, presence: true

  def add_invitee(invitee)
    self.invitees.push(invitee)
    self.invitees.uniq!
    save!
  end
end
