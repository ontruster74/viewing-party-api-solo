class CreateViewingPartiesUsersJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :viewing_parties_users, id: false do |t|
      t.integer :user_id
      t.integer :viewing_party_id
    end

    add_index :viewing_parties_users, :user_id
    add_index :viewing_parties_users, :viewing_party_id
    add_index :viewing_parties_users, [:user_id, :viewing_party_id], unique: true
  end
end
